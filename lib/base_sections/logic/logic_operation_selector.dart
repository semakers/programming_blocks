import 'package:programming_blocks/ui/data_selector/data_selector.dart';
import 'package:flutter/material.dart';

enum LogicOperation {
  and,
  or,
}

class LogicOperationSelector extends DataSelector {
  LogicOperationSelector({Key? key})
      : super(
          options: LogicOperation.values.map((e) => e.toString()).toList(),
          dataSelectorKey: 'LOGIC_OPERATOR',
          textColor: Colors.white,
          key: key,
        );

  @override
  Widget dataName(data) {
    if (data == LogicOperation.and.toString()) {
      return const Text(' & ');
    } else if (data == LogicOperation.or.toString()) {
      return const Text(' || ');
    }
    return const SizedBox.shrink();
  }
}
