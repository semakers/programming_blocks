import 'package:programming_blocks/programming_blocks.dart';
import 'package:programming_blocks/programming_blocks_dependency.dart';
import 'package:programming_blocks/ui/programming_blocks/controllers/read_base_methods.dart';

class ReadBlockController extends ReadBaseMethods {
  ReadBlockController({
    required ProgrammingBlockModel blockModel,
    required this.configBlockModel,
    required ProgrammingBlocksDependency programmingBlocks,
  }) : super(
          blockModel: blockModel,
          programmingBlocks: programmingBlocks,
        );

  final ConfigurationBlockModel? configBlockModel;
}
