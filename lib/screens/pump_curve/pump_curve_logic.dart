import 'dart:collection';
import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:variable_speed_pump/data_sources/preferences_sources.dart';
import 'package:variable_speed_pump/data_sources/pump_unit_sources.dart';
import 'package:variable_speed_pump/models/power_pump_unit_curve.dart';
import 'package:variable_speed_pump/models/pump_unit/pump_unit.dart';
import 'package:variable_speed_pump/utils/constants.dart';
import 'package:variable_speed_pump/utils/functions.dart';

class PowerPumpCurveLogic {
  late final PumpUnitSource _dbPumpUnitsSource;
  late final PreferencesSource _preferencesSource;
  final ValueNotifier<PumpUnit> pumpUnit = ValueNotifier(startingPU);
  final ValueNotifier<String> currentKey = ValueNotifier("");
  final ValueNotifier<LinkedHashMap<String, String>> pumpUnitNames =
      ValueNotifier(LinkedHashMap());

  late List<double> _headList;
  double minHead = 0.0;
  double maxHead = 0.0;

  final powerPUCurves = ValueNotifier<List<PowerPumpUnitCurve>>([]);

  PowerPumpCurveLogic({
    PumpUnitSource? source,
    PreferencesSource? preferences,
  }) {
    getSources(source: source, preferences: preferences);
  }

  void getSources({
    PumpUnitSource? source,
    PreferencesSource? preferences,
  }) async {
    this._dbPumpUnitsSource =
        source ?? await GetIt.I.getAsync<PumpUnitSource>();
    this._preferencesSource =
        preferences ?? await GetIt.I.getAsync<PreferencesSource>();
    pumpUnitNames.value = this._dbPumpUnitsSource.getListOfPumpUnits();
    openPumpCurves(_preferencesSource.getCurrentPUKey());
  }

  void openPumpCurves(String? key) {
    if (key != null) {
      pumpUnit.value = this._dbPumpUnitsSource.getPumpUnitWithKey(key);
      _preferencesSource.setCurrentPUKey(key);
    } else {
      final currentKey = _preferencesSource.getCurrentPUKey();
      if (currentKey != null) {
        pumpUnit.value = this._dbPumpUnitsSource.getPumpUnitWithKey(currentKey);
      } else {
        pumpUnit.value = this._dbPumpUnitsSource.getFirstPumpUnit();
      }
    }
    setupMinMaxHead();
    setupPowerPUCurvesWithHeads();
  }

  void setupMinMaxHead() {
    double min = pumpUnit.value.pumpCurvePoints.last.head;
    double max = pumpUnit.value.pumpCurvePoints.first.head;
    pumpUnit.value.pumpCurvePoints.map((e) => e.head).forEach((head) {
      if (head > max) max = head;
      if (head < min) min = head;
    });
    this.minHead = (min * 0.70).roundD(1);
    this.maxHead = (max * 0.98).roundD(1);
    double startHead = ((minHead + maxHead) * 0.6).roundD(1);
    this._headList = [startHead];
  }

  void setupPowerPUCurvesWithHeads() {
    powerPUCurves.value = _headList
        .map((head) => PowerPumpUnitCurve.fromNormalCurvePoints(
            head: head, normalPumpCurvePoints: pumpUnit.value.pumpCurvePoints))
        .toList();
  }

  void changeMainHead(double newValue) {
    _headList[0] = newValue.roundD(1);
    setupPowerPUCurvesWithHeads();
  }
}
