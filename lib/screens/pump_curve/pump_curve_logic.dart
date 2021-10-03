import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:variable_speed_pump/data_sources/pump_unit_sources.dart';
import 'package:variable_speed_pump/models/power_pump_unit_curve.dart';
import 'package:variable_speed_pump/models/pump_unit/pump_unit.dart';
import 'package:variable_speed_pump/utils/functions.dart';

class PowerPumpCurveLogic {
  late final PumpUnitSource _dbPumpUnitsSource;
  late PumpUnit pumpUnit; //as parameter due we need to access motor later

  bool powerPUCurvesActive = true;

  late List<double> _headList;
  double minHead = 0.0;
  double maxHead = 0.0;

  final powerPUCurves = ValueNotifier<List<PowerPumpUnitCurve>>([]);

  PowerPumpCurveLogic({PumpUnitSource? source}) {
    getSources(source: source);
  }

  void getSources({PumpUnitSource? source}) async {
    this._dbPumpUnitsSource =
        source ?? await GetIt.I.getAsync<PumpUnitSource>();
    setupPumpCurves();
  }

  void setupPumpCurves() {
    pumpUnit = this._dbPumpUnitsSource.getFirstPumpUnit();
    if (powerPUCurvesActive) {
      setupMinMaxHead();
      setupPowerPUCurvesWithHeads();
    }
  }

  void setupMinMaxHead() {
    double min = pumpUnit.pumpCurvePoints.last.head;
    double max = pumpUnit.pumpCurvePoints.first.head;
    pumpUnit.pumpCurvePoints.map((e) => e.head).forEach((head) {
      if (head > max) max = head;
      if (head < min) min = head;
    });
    this.minHead = (min * 0.75).roundD(1);
    this.maxHead = (max * 0.98).roundD(1);
    double startHead = ((minHead + maxHead) * 0.6).roundD(1);
    this._headList = [startHead];
  }

  void setupPowerPUCurvesWithHeads() {
    powerPUCurves.value = _headList
        .map((head) => PowerPumpUnitCurve.fromNormalCurvePoints(
            head: head, normalPumpCurvePoints: pumpUnit.pumpCurvePoints))
        .toList();
  }

  void changeMainHead(double newValue) {
    _headList[0] = newValue.roundD(1);
    setupPowerPUCurvesWithHeads();
  }
}
