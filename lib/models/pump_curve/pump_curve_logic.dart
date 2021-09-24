import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:variable_speed_pump/models/data_sources/pump_curves_sources.dart';

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
    this._currentPumpCurvePoints =
        pumpCurves ?? GetIt.I<PumpCurvesSources>().getPumpCurves(null);
    this.headList = heads ?? [_currentPumpCurvePoints.last.head];
    setupPumpCurvesWithHeads();
  }

  void setupPumpCurvesWithHeads() {
    pumpCurvesWithHeads.value =
        headList.map((head) => curveWithHead(head)).toList();
  }

  List<PumpCurvePoint> curveWithHead(double head) {
    return PumpCurve(rpm: 3600.0, points: _currentPumpCurvePoints)
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
