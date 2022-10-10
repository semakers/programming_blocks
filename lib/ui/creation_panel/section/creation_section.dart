import 'package:flutter/material.dart';
import 'package:programming_blocks/ui/creation_panel/section/creation_section_data.dart';

abstract class CreationSection extends StatelessWidget {
  const CreationSection({
    Key? key,
    required this.creationSectionData,
  }) : super(key: key);

  final CreationSectionData creationSectionData;
  Widget buildSection(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return buildSection(context);
  }
}
