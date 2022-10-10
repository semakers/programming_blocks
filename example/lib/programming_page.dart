import 'dart:convert';

import 'package:example/example_algorithms/calculator_algorithm.dart';
import 'package:example/example_sections/console/console_section.dart';
import 'package:example/example_sections/string/strings_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_console_widget/flutter_console.dart';
import 'package:programming_blocks/programming_blocks.dart';

class ProgrammingPage extends StatelessWidget {
  const ProgrammingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final FlutterConsoleController consoleController =
        FlutterConsoleController();
    consoleController.hide();
    ProgrammingBlocksProjectModel? projectModel;
    projectModel = ProgrammingBlocksProjectModel.fromJson(
      jsonDecode(
        CalculatorAlgorithm.serializedCode,
      ),
    );

    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          Expanded(
            child: ProgrammingBlocks(
              projectModel: projectModel,
              onProjectChange: (projectModel) async {
                await Clipboard.setData(
                    ClipboardData(text: jsonEncode(projectModel.toJson())));
              },
              onChangeRunningState: (runningState) async {
                switch (runningState) {
                  case RunningState.running:
                    consoleController.show();
                    break;
                  case RunningState.stoped:
                    consoleController.clear();
                    consoleController.hide();

                    break;
                }
              },
              enableFunctions: true,
              sections: [
                ConsoleSection(
                  consoleController: consoleController,
                ),
                FollowSection(),
                LogicSection(),
                NumbersSection(),
                StringsSection(),
              ],
            ),
          ),
          FlutterConsole(
            controller: consoleController,
            width: size.width,
            height: size.height / 3.0,
          ),
        ],
      ),
    ));
  }
}
