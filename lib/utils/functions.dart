import 'dart:math';

import 'package:flutter/services.dart';

extension Ex on double {
  double roundD(int places) {
    num mod = pow(10.0, places);
    return ((this * mod).round().toDouble() / mod);
  }
}

bool invalidDouble(String text) {
  double? numericValue = double.tryParse(text);
  if (numericValue == null) return true;
  return false;
}

// https://stackoverflow.com/questions/54454983/allow-only-two-decimal-number-in-flutter-input
class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({
    int? decimalRange,
    required bool activatedNegativeValues,
  }) : assert(decimalRange == null || decimalRange >= 0,
            'DecimalTextInputFormatter declaration error') {
    String dp = (decimalRange != null && decimalRange > 0)
        ? '([.][0-9]{0,$decimalRange}){0,1}'
        : '';
    String num = '[0-9]*$dp';

    if (activatedNegativeValues) {
      _exp = RegExp('^((((-){0,1})|((-){0,1}[0-9]$num))){0,1}\$');
    } else {
      _exp = RegExp('^($num){0,1}\$');
    }
  }

  late RegExp _exp;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (_exp.hasMatch(newValue.text)) {
      return newValue;
    }
    return oldValue;
  }
}
