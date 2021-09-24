import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:variable_speed_pump/models/data_sources/pump_curves_sources.dart';
import 'package:variable_speed_pump/utils/math_functions.dart';

import '../pump_curve.dart';
import '../pump_curve_point.dart';

class PumpCurveLogic {
  late List<PumpCurvePoint> _currentPumpCurvePoints;
  List<PumpCurvePoint> get currentPumpCurvePoints => _currentPumpCurvePoints;
  set currentPumpCurvePoints(List<PumpCurvePoint> newList) {
    if (newList.length > 4) _currentPumpCurvePoints = newList;
  }

  late List<double> _headList;
  ValueNotifier<List<double>> headList = ValueNotifier<List<double>>([]);

  final pumpCurvesWithHeads = ValueNotifier<List<List<PumpCurvePoint>>>([]);

  double minHead = 0.0;
  double maxHead = 0.0;

  PumpCurveLogic({List<PumpCurvePoint>? pumpCurves, List<double>? heads}) {
    this._currentPumpCurvePoints =
        pumpCurves ?? GetIt.I<PumpCurvesSources>().getPumpCurves(null);

    setupMinMaxHead();
    double startHead = ((minHead + maxHead) * 0.6).roundD(1);
    this._headList = heads ?? [startHead];

    setupPumpCurvesWithHeads();
  }

  void setupPumpCurvesWithHeads() {
    headList.value = _headList;
    pumpCurvesWithHeads.value =
        _headList.map((head) => curveWithHead(head)).toList();
    headList.notifyListeners();
  }

  List<PumpCurvePoint> curveWithHead(double head) {
    return PumpCurve(rpm: 3600.0, points: _currentPumpCurvePoints)
        .powerPumpCurveWithHead(head: head, steps: 120)
        .points
        .reversed
        .toList();
  }

  void changeHead(double oldValue, double newValue) {
    if (curveWithHead(newValue).isEmpty) return;
    int index = _headList.indexWhere((element) => element == oldValue);
    if (index != -1) {
      _headList[index] = newValue.roundD(1);
    } else {
      _headList.add(newValue.roundD(1));
    }
    setupPumpCurvesWithHeads();
  }

  void setupMinMaxHead() {
    double min = _currentPumpCurvePoints.last.head;
    double max = _currentPumpCurvePoints.first.head;
    _currentPumpCurvePoints.map((e) => e.head).forEach((head) {
      if (head > max) max = head;
      if (head < min) min = head;
    });
    this.minHead = (min * 0.75).roundD(1);
    this.maxHead = (max * 0.98).roundD(1);
  }

  // void changeHeadListTest() {
  //   if (_headList.first == 30) {
  //     _headList.first = 40.0;
  //   } else {
  //     _headList.first = 30.0;
  //   }
  //   setupPumpCurvesWithHeads();
  // }
}
