import 'package:flutter/material.dart';
import 'package:programming_blocks/ui/creation_panel/section/creation_section.dart';
import 'package:programming_blocks/ui/creation_panel/section/creation_section_data.dart';

abstract class DividedSection extends CreationSection {
  const DividedSection({
    Key? key,
    required CreationSectionData creationSectionData,
    required this.subSections,
  }) : super(creationSectionData: creationSectionData, key: key);

  final Map<String, CreationSection> subSections;

  @override
  Widget buildSection(BuildContext context) {
    ValueNotifier<int> selectedSubSection = ValueNotifier(0);
    return ValueListenableBuilder<int>(
        valueListenable: selectedSubSection,
        builder: (_, subSection, __) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: subSections.values.toList()[subSection],
              ),
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: subSections.keys
                        .map(
                          (e) => InkWell(
                            onTap: () {
                              selectedSubSection.value =
                                  subSections.keys.toList().indexOf(e);
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Text(
                                e,
                                style: subSections.keys.toList().indexOf(e) ==
                                        subSection
                                    ? TextStyle(
                                        color: creationSectionData.color,
                                        fontWeight: FontWeight.bold,
                                      )
                                    : null,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          );
        });
  }
}
