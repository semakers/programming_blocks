import 'package:programming_blocks/function_section/function_block_type.dart';
import 'package:programming_blocks/function_section/function_config_blockmodel.dart';
import 'package:programming_blocks/programming_blocks.dart';
import 'package:programming_blocks/programming_blocks_dependency.dart';

class ProjectModelSingletonBuilder {
  static final ProjectModelSingletonBuilder _projectModelSingletonBuilder =
      ProjectModelSingletonBuilder._internal();

  factory ProjectModelSingletonBuilder() {
    return _projectModelSingletonBuilder;
  }

  ProgrammingBlocksProjectModel? projectModel;

  ProgrammingBlocksProjectModel build({
    required double defaultFuntionSize,
    required String mainFunctionName,
    required bool drawMainScope,
  }) {
    final mainFuntion = FunctionConfigBlockModel(
      configArguments: {
        'function_uuid': ProgrammingBlocksDependency.mainCanvasUuid,
        'widht': defaultFuntionSize,
        'height': defaultFuntionSize,
        'draw_scope': drawMainScope
      },
      typeName: FunctionBlockType.typeName,
      uuid: ProgrammingBlocksDependency.mainCanvasUuid,
      name: mainFunctionName,
    );
    projectModel ??= ProgrammingBlocksProjectModel(functionsCanvas: [
      mainFuntion.toCanvasModel,
    ], configurationModels: [
      mainFuntion,
    ]);
    return projectModel!;
  }

  ProjectModelSingletonBuilder._internal();
}
