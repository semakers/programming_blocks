import 'package:collection/collection.dart';
import 'package:programming_blocks/programming_blocks.dart';
import 'package:programming_blocks/programming_blocks_dependency.dart';

abstract class ReadBaseMethods {
  ReadBaseMethods({
    required this.blockModel,
    required ProgrammingBlocksDependency programmingBlocks,
  }) : _programmingBlocks = programmingBlocks;

  final ProgrammingBlockModel blockModel;
  final ProgrammingBlocksDependency _programmingBlocks;

  Future readInput({
    required String blockInputTargetKey,
  }) async {
    final inputModel = blockModel.inputs
        .firstWhereOrNull((element) => element.key == blockInputTargetKey);
    if (inputModel != null) {
      if (inputModel.programmingBlock != null) {
        return await _programmingBlocks.readBlock(
            blockModel: inputModel.programmingBlock!);
      } else {
        return inputModel.defaultData;
      }
    } else {
      return null;
    }
  }

  Future readSelector({
    required String dataSelectorKey,
  }) async {
    final selector = blockModel.selectors
        .firstWhereOrNull((element) => element.key == dataSelectorKey);
    if (selector != null) {
      return selector.data;
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>> readArgsOfSelectedVariable({
    required String variableType,
  }) async {
    final configUuid = await readSelector(
      dataSelectorKey: '${variableType}_SELECTION',
    );
    final ConfigurationBlockModel configurationBlockModel =
        _programmingBlocks.panelController.configByuuid(uuid: configUuid)!;
    return configurationBlockModel.configArguments;
  }
}
