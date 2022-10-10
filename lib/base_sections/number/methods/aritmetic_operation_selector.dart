import 'package:programming_blocks/ui/data_selector/data_selector.dart';
import 'package:flutter/material.dart';

enum AritmeticOperation {
  add,
  sub,
  mul,
  div,
  mod,
}

class AritmeticOperationSelector extends DataSelector {
  AritmeticOperationSelector({Key? key})
      : super(
          options: AritmeticOperation.values.map((e) => e.toString()).toList(),
          dataSelectorKey: 'ARITMETIC_OPERATOR',
          textColor: Colors.white,
          key: key,
        );

  @override
  String dataName(data) {
    if (data == AritmeticOperation.mul.toString()) {
      return ' x';
    } else if (data == AritmeticOperation.div.toString()) {
      return ' /';
    } else if (data == AritmeticOperation.add.toString()) {
      return ' +';
    } else if (data == AritmeticOperation.sub.toString()) {
      return ' - ';
    } else if (data == AritmeticOperation.mod.toString()) {
      return ' % ';
    }
    return '';
  }
}
