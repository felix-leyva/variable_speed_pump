import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:variable_speed_pump/data_sources/preferences_sources.dart';
import 'package:variable_speed_pump/data_sources/pump_unit_sources.dart';
import 'package:variable_speed_pump/models/pump_curve/pump_curve.dart';
import 'package:variable_speed_pump/models/pump_unit/pump_unit.dart';
import 'package:variable_speed_pump/utils/constants.dart';

class VariableSpeedCurvesLogic {
  late final PumpUnitSource _dbPumpUnitsSource;
  late final PreferencesSource _preferencesSource;
  final ValueNotifier<PumpUnit> pumpUnit = ValueNotifier(startingPU);
  final ValueNotifier<String> currentKey = ValueNotifier("");
  final ValueNotifier<LinkedHashMap<String, String>> pumpUnitNames =
      ValueNotifier(LinkedHashMap());
  final ValueNotifier<List<PumpCurve>> speedPumpCurves = ValueNotifier([]);

  VariableSpeedCurvesLogic({
    PumpUnitSource? source,
    PreferencesSource? preferences,
  }) {
    getSources(source: source, preferences: preferences);
  }

  void getSources(
      {PumpUnitSource? source, PreferencesSource? preferences}) async {
    this._dbPumpUnitsSource =
        source ?? await GetIt.I.getAsync<PumpUnitSource>();
    this._preferencesSource =
        preferences ?? await GetIt.I.getAsync<PreferencesSource>();
    pumpUnitNames.value = _dbPumpUnitsSource.getListOfPumpUnits();
    setPumpCurves(_preferencesSource.getCurrentPUKey());
  }

  void setPumpCurves(String? currentPUKey) {
    String pumpUnitKey = currentPUKey ?? '';
    pumpUnit.value = _dbPumpUnitsSource.getPumpUnitWithKey(pumpUnitKey);
    _preferencesSource.setCurrentPUKey(pumpUnit.value.key);

    speedPumpCurves.value =
        pumpUnit.value.pumpCurve.pumpCurvesWithSpeedRanges(steps: 5) ?? [];
  }
}
