import 'package:flutter/material.dart';
import 'package:programming_blocks/programming_blocks_dependency.dart';

class StopArea extends StatelessWidget {
  const StopArea({
    Key? key,
    required this.stopBuilder,
  }) : super(key: key);

  final Widget Function()? stopBuilder;

  @override
  Widget build(BuildContext context) {
    final programmingBlocks = ProgrammingBlocksDependency.of(context)!;
    final panelController = programmingBlocks.panelController;
    return InkWell(
        onTap: () {
          panelController.runningOperation!.cancel();
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: stopBuilder == null
              ? Stack(
                  children: [
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              50.0,
                            ),
                          ),
                          child: const SizedBox(
                            width: 40,
                            height: 40,
                          ),
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.stop_circle,
                      size: 50.0,
                      color: Colors.red,
                    ),
                  ],
                )
              : stopBuilder!(),
        ));
  }
}
