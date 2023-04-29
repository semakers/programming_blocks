import 'package:programming_blocks/ui/data_selector/data_selector.dart';
import 'package:flutter/material.dart';

enum ComparationOperation {
  min,
  minEqual,
  equal,
  diferent,
  max,
  maxEqual,
}

class ComparationOperationSelector extends DataSelector {
  ComparationOperationSelector({Key? key})
      : super(
          options:
              ComparationOperation.values.map((e) => e.toString()).toList(),
          dataSelectorKey: 'COMPARATION_OPERATOR',
          defaultSelected: ComparationOperation.equal.toString(),
          textColor: Colors.white,
          key: key,
        );

  @override
  Widget dataName(data) {
    if (data == ComparationOperation.min.toString()) {
      return const Text(' < ');
    } else if (data == ComparationOperation.minEqual.toString()) {
      return const Text(' <= ');
    } else if (data == ComparationOperation.equal.toString()) {
      return const Text(' = ');
    } else if (data == ComparationOperation.diferent.toString()) {
      return const Text(' != ');
    } else if (data == ComparationOperation.max.toString()) {
      return const Text(' > ');
    } else if (data == ComparationOperation.maxEqual.toString()) {
      return const Text(' >= ');
    }

    return const SizedBox.shrink();
  }
}
