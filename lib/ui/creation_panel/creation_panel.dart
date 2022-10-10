import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:programming_blocks/function_section/function_section.dart';
import 'package:programming_blocks/programming_blocks.dart';
import 'package:programming_blocks/programming_blocks_dependency.dart';
import 'package:programming_blocks/ui/creation_panel/panel_actions/left_panel_action/left_panel_action.dart';
import 'package:programming_blocks/ui/creation_panel/panel_actions/rigth_panel_action/rigth_panel_action.dart';
import 'package:programming_blocks/ui/creation_panel/section/creation_section_data.dart';
import 'package:programming_blocks/ui/drag_and_drop/programming_block_drag_target.dart';

class CreationPanel extends StatefulWidget {
  const CreationPanel({
    this.animationCurve,
    this.animationDuration,
    this.backgorundColor,
    required this.child,
    required this.height,
    Key? key,
    this.openCloseBuilder,
    this.creationSectionButtonBuilder,
    this.trashBuilder,
    this.runBuilder,
    this.stopBuilder,
  }) : super(key: key);

  final Curve? animationCurve;
  final Duration? animationDuration;
  final Color? backgorundColor;
  final Widget child;
  final double height;
  final Widget Function()? openCloseBuilder;
  final Widget Function()? stopBuilder;
  final Widget Function(bool onBlockEnter)? trashBuilder;
  final Widget Function(Color? enterBlockColor)? runBuilder;
  final Widget Function(
      BuildContext context,
      CreationSectionData creationSectionData,
      bool selected)? creationSectionButtonBuilder;

  @override
  State<CreationPanel> createState() => _CreationPanelState();
}

class _CreationPanelState extends State<CreationPanel>
    with TickerProviderStateMixin {
  late Animation<double> _animation;
  final ValueNotifier<double> _animationNotifier = ValueNotifier(0);
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.animationCurve ?? Curves.linear,
    ));
    _controller.duration = widget.animationDuration ??
        const Duration(
          milliseconds: 300,
        );
    _animation.addListener(() {
      _animationNotifier.value = (widget.height) * _animation.value;
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    final panelController =
        ProgrammingBlocksDependency.of(context)?.panelController;

    panelController?.open = () {
      if (_animation.value == 0.0) {
        _controller.forward();
      }
    };
    panelController?.close = () {
      if (_animation.value == 1.0) {
        _controller.reverse();
      }
    };
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final programmingBlocks = ProgrammingBlocksDependency.of(context)!;
    final canvasController = programmingBlocks.canvasController;
    final panelController = programmingBlocks.panelController;
    final enableFunctions = programmingBlocks.enableFunctions;

    return ClipRect(
      child: BlockDragTarget(
        onBlockDroped: (blockModel) {
          canvasController.currentSingleCanvas!.newBlock = blockModel;
          return true;
        },
        onBlockEnter: null,
        onBlockExit: null,
        child: Stack(children: [
          widget.child,
          LeftPanelAction(
            animationNotifier: _animationNotifier,
            runBuilder: widget.runBuilder,
            stopBuilder: widget.stopBuilder,
          ),
          RigthPanelAction(
            animationNotifier: _animationNotifier,
            trashBuilder: widget.trashBuilder,
            openCloseBuilder: widget.openCloseBuilder,
          ),
          ValueListenableBuilder<double>(
              valueListenable: _animationNotifier,
              builder: (_, animationValue, __) {
                return Positioned.fill(
                  bottom: (-widget.height) + animationValue,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: _Panel(
                      trashBuilder: widget.trashBuilder,
                      animation: _animation,
                      animationController: _controller,
                      creationSectionButtonBuilder:
                          widget.creationSectionButtonBuilder,
                      height: widget.height,
                      openCloseWidget: widget.openCloseBuilder == null
                          ? null
                          : widget.openCloseBuilder!(),
                      backgroundColor: widget.backgorundColor,
                      sections: enableFunctions
                          ? panelController.sections
                          : panelController.sections
                              .where((element) => element is! FunctionsSection)
                              .toList(),
                    ),
                  ),
                );
              })
        ]),
      ),
    );
  }
}

class _Panel extends StatefulWidget {
  const _Panel({
    required this.animation,
    required this.animationController,
    this.backgroundColor,
    required this.height,
    Key? key,
    this.openCloseWidget,
    required this.sections,
    required this.creationSectionButtonBuilder,
    required this.trashBuilder,
  }) : super(key: key);
  final Animation<double> animation;
  final AnimationController animationController;
  final Color? backgroundColor;
  final double height;
  final Widget? openCloseWidget;
  final List<CreationSection> sections;
  final Widget Function(bool onBlockEnter)? trashBuilder;
  final Widget Function(
      BuildContext context,
      CreationSectionData creationSectionData,
      bool selected)? creationSectionButtonBuilder;

  @override
  State<_Panel> createState() => _PanelState();
}

class _PanelState extends State<_Panel> {
  late ValueNotifier<CreationSection> sectionNotifier;

  final GlobalKey globalKey = GlobalKey();
  Size? columnSize;

  @override
  void initState() {
    super.initState();
    sectionNotifier = ValueNotifier(widget.sections.first);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      columnSize =
          (globalKey.currentContext!.findRenderObject()! as RenderBox).size;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    final ValueNotifier<bool> enableForwardNotifier = ValueNotifier(true);

    return NotificationListener(
      onNotification: (t) {
        if (t is ScrollEndNotification) {
          enableForwardNotifier.value = true;
        }

        if (t is UserScrollNotification &&
            t.direction == ScrollDirection.reverse) {
          enableForwardNotifier.value = false;
        } else if (t is UserScrollNotification &&
            t.direction == ScrollDirection.forward) {
          enableForwardNotifier.value = true;
        }
        return true;
      },
      child: ValueListenableBuilder<bool>(
          valueListenable: enableForwardNotifier,
          builder: (_, forward, __) {
            return SingleChildScrollView(
              controller: scrollController,
              physics: forward
                  ? const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    )
                  : const NeverScrollableScrollPhysics(),
              child: Container(
                height: widget.height,
                color: widget.backgroundColor ?? const Color(0xffd0d0d0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ValueListenableBuilder<CreationSection>(
                          valueListenable: sectionNotifier,
                          builder: (_, section, __) {
                            return section;
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: SizedBox(
                        width: columnSize?.width,
                        child: SingleChildScrollView(
                          child: Column(
                            key: globalKey,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: widget.sections
                                .map(
                                  (e) => InkWell(
                                    onTap: () {
                                      sectionNotifier.value = e;
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: ValueListenableBuilder<
                                              CreationSection>(
                                          valueListenable: sectionNotifier,
                                          builder: (_, section, __) {
                                            return widget
                                                        .creationSectionButtonBuilder !=
                                                    null
                                                ? widget.creationSectionButtonBuilder!(
                                                    context,
                                                    e.creationSectionData,
                                                    section == e)
                                                : section == e
                                                    ? Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 8,
                                                                right: 4),
                                                        color: e
                                                            .creationSectionData
                                                            .color,
                                                        height: 25,
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              e.creationSectionData
                                                                  .name,
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                    : Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Container(
                                                            color: e
                                                                .creationSectionData
                                                                .color,
                                                            width: 4,
                                                            height: 25,
                                                          ),
                                                          const SizedBox(
                                                            width: 4,
                                                          ),
                                                          Text(
                                                            e.creationSectionData
                                                                .name,
                                                          ),
                                                          const SizedBox(
                                                            width: 4,
                                                          ),
                                                        ],
                                                      );
                                          }),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}

class CreationPanelController {
  CreationPanelController({
    required this.sections,
    required List<ConfigurationBlockModel?> configBlockModels,
  })  : configListListeneble =
            ValueNotifier<List<ConfigurationBlockModel?>>(configBlockModels),
        configListeners =
            configBlockModels.map((e) => ValueNotifier(e)).toList();

  final List<CreationSection> sections;
  final List<ValueNotifier<ConfigurationBlockModel?>?> configListeners;
  final ValueNotifier<List<ConfigurationBlockModel?>> configListListeneble;
  final ValueNotifier<bool> draggingBlockListenable =
      ValueNotifier<bool>(false);
  final ValueNotifier<RunningState> runningStateListenable =
      ValueNotifier(RunningState.stoped);
  CancelableOperation? runningOperation;

  late VoidCallback _open;
  late VoidCallback _close;
  bool isOpen = false;

  VoidCallback get open => _open;
  VoidCallback get close => _close;

  set open(VoidCallback callback) {
    _open = () {
      callback();
      isOpen = true;
    };
  }

  set close(VoidCallback callback) {
    _close = () {
      callback();
      isOpen = false;
    };
  }

  void draggingBlock() {
    draggingBlockListenable.value = true;
  }

  void blockDroped() {
    draggingBlockListenable.value = false;
  }

  void updateConfigList({required List<ConfigurationBlockModel?> configList}) {
    configListListeneble.value = configList.where((element) => true).toList();
  }

  void refreshConfigList() {
    configListListeneble.value =
        configListListeneble.value.where((element) => true).toList();
  }

  void removeConfigModel({
    required ConfigurationBlockModel configModel,
  }) {
    configListListeneble.value = configListListeneble.value
        .where(
          (element) => element?.uuid != configModel.uuid,
        )
        .toList();
  }

  void addConfigModel({
    required ConfigurationBlockModel configModel,
  }) {
    configListListeneble.value.add(configModel);
    refreshConfigList();
  }

  ValueNotifier<ConfigurationBlockModel?>? listenerByConfig(
      {required String uuid}) {
    for (var listener in configListeners) {
      if (listener?.value?.uuid == uuid) {
        return listener;
      }
    }
    return null;
  }

  ConfigurationBlockModel? configByuuid({required String uuid}) {
    for (var listener in configListeners) {
      if (listener?.value?.uuid == uuid) {
        return listener?.value;
      }
    }
    return null;
  }
}
