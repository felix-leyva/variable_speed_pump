import 'package:flutter/material.dart';
import 'package:variable_speed_pump/utils/constants.dart';

import '../pump_curve.dart';
import '../pump_curve_point.dart';

class PumpCurveLogic {
  late List<double> headList;
  late List<PumpCurvePoint> _currentPumpCurvePoints;

  List<PumpCurvePoint> get currentPumpCurvePoints => _currentPumpCurvePoints;
  set currentPumpCurvePoints(List<PumpCurvePoint> newList) {
    if (newList.length > 4) _currentPumpCurvePoints = newList;
  }

  final pumpCurvesWithHeads = ValueNotifier<List<List<PumpCurvePoint>>>([]);

  PumpCurveLogic({List<PumpCurvePoint>? pumpCurves, List<double>? heads}) {
    headList = heads ?? [30, 50];
    _currentPumpCurvePoints = pumpCurves ?? pumpCurve;
    setupPumpCurvesWithHeads();
  }

  void setupPumpCurvesWithHeads() {
    pumpCurvesWithHeads.value =
        headList.map((head) => curveWithHead(head)).toList();
  }

  List<PumpCurvePoint> curveWithHead(double head) {
    return PumpCurve(rpm: 3600.0, points: pumpCurve)
        .powerPumpCurveWithHead(head: head, steps: 120)
        .points
        .reversed
        .toList();
  }

  void changeHeadListTest() {
    if (headList.first == 30) {
      headList.first = 40.0;
    } else {
      headList.first = 30.0;
    }
    setupPumpCurvesWithHeads();
  }
}
