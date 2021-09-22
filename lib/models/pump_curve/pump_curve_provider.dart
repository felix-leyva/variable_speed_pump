import 'package:flutter/material.dart';
import 'package:variable_speed_pump/utils/constants.dart';

import '../pump_curve.dart';
import '../pump_curve_point.dart';

class PumpCurveProvider extends ChangeNotifier {
  final List<double> headList = [30, 50];

  List<List<PumpCurvePoint>> get pumpCurvesWithHeads =>
      headList.map((head) => curveWithHead(head)).toList();

  List<PumpCurvePoint> curveWithHead(double head) {
    final powerPumpCurvePoints = PumpCurve(rpm: 3600.0, points: pumpCurve)
        .powerPumpCurveWithHead(head: head, steps: 120)
        .points
        .reversed
        .toList();

    return powerPumpCurvePoints;
  }

  void changeHeadListTest() {
    if (headList.first == 30) {
      headList.first = 40.0;
    } else {
      headList.first = 30.0;
    }
    notifyListeners();
  }
}
