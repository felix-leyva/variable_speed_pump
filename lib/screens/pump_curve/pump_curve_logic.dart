import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:variable_speed_pump/data_sources/pump_curves_sources.dart';
import 'package:variable_speed_pump/models/power_pump_curve.dart';
import 'package:variable_speed_pump/models/power_pump_unit_curve.dart';
import 'package:variable_speed_pump/models/pump_curve/pump_curve.dart';
import 'package:variable_speed_pump/models/pump_curve_points/pump_curve_point.dart';
import 'package:variable_speed_pump/utils/functions.dart';

class PowerPumpCurveLogic {
  bool powerPUCurvesActive = true;

  late List<PumpCurvePoint> _currentPumpCurvePoints;
  List<PumpCurvePoint> get currentPumpCurvePoints => _currentPumpCurvePoints;
  set currentPumpCurvePoints(List<PumpCurvePoint> newList) {
    if (newList.length > 4) _currentPumpCurvePoints = newList;
  }

  late List<double> _headList;
  ValueNotifier<List<double>> headList = ValueNotifier<List<double>>([]);

  final powerPumpCurves = ValueNotifier<List<PowerPumpCurve>>([]);
  final powerPUCurves = ValueNotifier<List<PowerPumpUnitCurve>>([]);

  double minHead = 0.0;
  double maxHead = 0.0;

  PowerPumpCurveLogic({List<PumpCurvePoint>? pumpCurves, List<double>? heads}) {
    this._currentPumpCurvePoints =
        pumpCurves ?? GetIt.I<PumpCurvesSources>().getPumpCurves(null);

    setupMinMaxHead();
    double startHead = ((minHead + maxHead) * 0.6).roundD(1);
    this._headList = heads ?? [startHead];

    updateValueNotifiers();
  }

  void setupPowerPumpCurvesWithHeads() {
    powerPumpCurves.value = _headList.map((head) {
      final List<PumpCurvePoint> points = curveWithHead(head);
      return PowerPumpCurve.fromPointsVariablePower(
          head: head, variablePowerPoints: points);
    }).toList();
  }

  void setupPowerPUCurvesWithHeads() {
    powerPUCurves.value = powerPumpCurves.value
        .map((powerPumpCurve) => powerPumpCurve.generatePowerPUCurve())
        .toList();
  }

  //TODO: remove this function because headlist valuenotifier wont be used anymore
  void setupHeadList() {
    headList.value = _headList;
    //headList.notifyListeners();
  }

  ///Generates a PumpCurve with the list of points and then
  ///returns the variable power pump curve
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
    updateValueNotifiers();
  }

  void changeMainHead(double newValue) {
    _headList[0] = newValue.roundD(1);
    updateValueNotifiers();
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

  void updateValueNotifiers() {
    setupHeadList();
    setupPowerPumpCurvesWithHeads();
    if (powerPUCurvesActive) setupPowerPUCurvesWithHeads();
  }
}
