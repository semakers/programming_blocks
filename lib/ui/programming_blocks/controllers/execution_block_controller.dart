import 'package:programming_blocks/programming_blocks.dart';
import 'package:programming_blocks/programming_blocks_dependency.dart';
import 'package:programming_blocks/ui/programming_blocks/controllers/read_base_methods.dart';

class ExecutionBlockController extends ReadBaseMethods {
  ExecutionBlockController({
    required ProgrammingBlockModel blockModel,
    required ProgrammingBlocksDependency programmingBlocks,
  })  : _programmingBlocks = programmingBlocks,
        super(
          blockModel: blockModel,
          programmingBlocks: programmingBlocks,
        );

  final ProgrammingBlocksDependency _programmingBlocks;

  Future<void> execute({
    required ProgrammingBlockModel blockModel,
  }) {
    return _programmingBlocks.executeBlock(
      blockModel: blockModel,
    );
  }

  Future<void> updateSelectedVariable(
      {required String variableType,
      required Map<String, dynamic> configArguments}) async {
    final configUuid = await readSelector(
      dataSelectorKey: '${variableType}_SELECTION',
    );
    final ConfigurationBlockModel configurationBlockModel =
        _programmingBlocks.panelController.configByuuid(uuid: configUuid)!;
    configurationBlockModel.configArguments = configArguments;
  }
}
