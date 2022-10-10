import 'package:flutter/material.dart';

enum CreationPanelActionAlignment {
  left,
  center,
  rigth,
}

class CreationPanelAction extends StatelessWidget {
  const CreationPanelAction(
      {Key? key,
      required this.align,
      required this.child,
      required this.animationNotifier})
      : super(key: key);

  final CreationPanelActionAlignment align;
  final Widget child;
  final ValueNotifier<double> animationNotifier;

  @override
  Widget build(BuildContext context) {
    late Alignment alignment;

    switch (align) {
      case CreationPanelActionAlignment.left:
        alignment = Alignment.bottomLeft;
        break;
      case CreationPanelActionAlignment.center:
        alignment = Alignment.bottomCenter;
        break;
      case CreationPanelActionAlignment.rigth:
        alignment = Alignment.bottomRight;
        break;
    }

    return ValueListenableBuilder<double>(
        valueListenable: animationNotifier,
        builder: (_, animationValue, __) {
          return Positioned.fill(
            bottom: animationValue,
            child: Align(
              alignment: alignment,
              child: child,
            ),
          );
        });
  }
}
