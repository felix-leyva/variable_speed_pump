import 'dart:async';
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:variable_speed_pump/data_sources/preferences_sources.dart';
import 'package:variable_speed_pump/data_sources/pump_unit_sources.dart';
import 'package:variable_speed_pump/models/pump_curve_point_input/pump_curve_point_input.dart';
import 'package:variable_speed_pump/models/pump_curve_point_input/pump_curve_point_input_adapter.dart';
import 'package:variable_speed_pump/models/pump_unit/pump_unit.dart';
import 'package:variable_speed_pump/utils/constants.dart';

class PumpCurveInputLogic {
  late final PumpUnitSource source;
  late final PreferencesSource preferencesSource;
  final ValueNotifier<PumpUnit> pumpUnit = ValueNotifier(startingPU);
  Timer? fieldDebounce;

  //TODO: function to show charts using PumpUnit efficiency instead of PumpEnd Eff
  final ValueNotifier<bool> editEff = ValueNotifier(true);
  final ValueNotifier<String> currentKey = ValueNotifier("");

  final ValueNotifier<List<PumpCurvePointInput>> pumpCurvePointInputs =
      ValueNotifier([]);
  final ValueNotifier<LinkedHashMap<String, String>> pumpUnitNames =
      ValueNotifier(LinkedHashMap());

  PumpCurveInputLogic({
    PumpUnitSource? source,
    String? pumpUnitKey,
    PumpUnit? startingPumpUnit,
    PreferencesSource? preferenceSource,
  }) {
    getSource(source, preferenceSource, pumpUnitKey, startingPumpUnit);
  }

  void getSource(PumpUnitSource? source, PreferencesSource? preferenceSource,
      String? pumpUnitKey, PumpUnit? startingPumpUnit) async {
    this.source = source ?? await GetIt.I.getAsync<PumpUnitSource>();
    this.preferencesSource =
        preferenceSource ?? await GetIt.I.getAsync<PreferencesSource>();
    pumpUnitNames.value = this.source.getListOfPumpUnits();

    currentKey.value = pumpUnitKey ??
        preferencesSource.getCurrentPUKey() ??
        pumpUnitNames.value.keys.first;

    if (startingPumpUnit != null) {
      pumpUnit.value = startingPumpUnit;
      currentKey.value = pumpUnit.value.key;
      preferencesSource.setCurrentPUKey(currentKey.value);
      pumpCurvePointInputs.value = powerPumpCurvePointInputListFromPumpUnit(
        pumpUnit: pumpUnit.value,
        useEfficiency: editEff.value,
      );
    } else {
      openPumpUnit(currentKey.value);
    }
  }

  void openPumpUnit(String? key) {
    final String keyToOpen = key ?? preferencesSource.getCurrentPUKey() ?? '';
    pumpUnit.value = this.source.getPumpUnitWithKey(keyToOpen);

    currentKey.value = pumpUnit.value.key;
    preferencesSource.setCurrentPUKey(currentKey.value);

    pumpCurvePointInputs.value = powerPumpCurvePointInputListFromPumpUnit(
      pumpUnit: pumpUnit.value,
      useEfficiency: editEff.value,
    );

    _updateValueNotifiers();
  }

  void toggleEditCurveEfficiencyPower() {
    editEff.value = !editEff.value;
  }

  void updateFlow(int pointIndex, double newFlow) {
    //TODO: add validation considering previous and next points
    _debounceFunction(() {
      final pumpCurveCopy = pumpCurvePointInputs.value;
      pumpCurveCopy[pointIndex].flow = newFlow;
      pumpCurvePointInputs.value = pumpCurveCopy;
    });
  }

  void updateHead(int pointIndex, double newHead) {
    //TODO: add validation considering previous and next points
    _debounceFunction(() {
      final pumpCurveCopy = pumpCurvePointInputs.value;
      pumpCurveCopy[pointIndex].head = newHead;
      pumpCurvePointInputs.value = pumpCurveCopy;
    });
  }

  void updateEffOrPower(int pointIndex, double newValue) {
    //TODO: add validation considering previous and next points
    _debounceFunction(() {
      final pumpCurveCopy = pumpCurvePointInputs.value;
      if (editEff.value) {
        pumpCurveCopy[pointIndex].efficiencyOrPower = newValue;
      } else {
        //TODO: estimate eff from power value
        // pumpCurvePointInputs.value[pointIndex].efficiencyOrPower = newValue;
      }
      pumpCurvePointInputs.value = pumpCurveCopy;
    });
  }

  void _savePumpUnitIntoDataSource() {
    _updatePumpUnitFromCurvePoints();
    source.updateOrAddPumpUnit(currentKey.value, pumpUnit.value);
    _updateValueNotifiers();
  }

  void _updateValueNotifiers() {
    pumpCurvePointInputs.notifyListeners();
    pumpUnit.value = source.getPumpUnitWithKey(currentKey.value);
    pumpUnitNames.value = this.source.getListOfPumpUnits();
  }

  void deleteCurrentPumpUnit() {
    if (pumpUnitNames.value.length > 1) source.deletePumpUnit(currentKey.value);
    currentKey.value = pumpUnitNames.value.keys.first;
    _updateValueNotifiers();
  }

  void _updatePumpUnitFromCurvePoints() {
    if (editEff.value) {
      this.pumpUnit.value = pumpUnitFromEffCurvePoints(
        pumpCurvePoints: this.pumpCurvePointInputs.value,
        pumpUnit: pumpUnit.value,
      );
    } else {
      //TODO: estimate the required motor
    }
  }

  void changePumpUnitName(String newName) {
    _debounceFunction(() {
      this.pumpUnit.value = pumpUnit.value.copyWith(name: newName);
    });
  }

  void _debounceFunction(VoidCallback function) {
    if (fieldDebounce?.isActive ?? false) fieldDebounce?.cancel();
    fieldDebounce = Timer(const Duration(milliseconds: 800), () {
      function();
      _savePumpUnitIntoDataSource();
    });
  }

  void createNewPumpUnitWithName(String newName) {
    PumpUnit newPumpUnit = pumpUnit.value.duplicateWithName(newName: newName);
    source.updateOrAddPumpUnit(newPumpUnit.key, newPumpUnit);
    openPumpUnit(newPumpUnit.key);
  }
}
