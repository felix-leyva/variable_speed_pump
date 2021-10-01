import 'dart:collection';

import 'package:hive/hive.dart';
import 'package:variable_speed_pump/models/pump_curve/pump_curve.dart';
import 'package:variable_speed_pump/models/pump_unit/pump_unit.dart';
import 'package:variable_speed_pump/utils/constants.dart';

abstract class PumpUnitSource {
  LinkedHashMap<String, String> getListOfPumpUnits();
  PumpUnit getPumpUnitWithKey(String key);
  PumpUnit getFirstPumpUnit();
  void updateOrAddPumpUnit(String key, PumpUnit pumpUnit);
  void deletePumpUnit(String key);
}

class PumpUnitDb extends PumpUnitSource {
  static const String pumpUnitBoxName = 'pump_unit_box';
  static const String pumpUnitNamesBoxName = 'pump_unit_names_box';
  static const String pumpUnitDefaultKey = 'default_pump_unit';
  static const String pumpUnitDefaultName = 'Default pump unit';

  Box<PumpUnit> pumpUnitBox;
  Box<String> pumpUnitNamesBox;

  PumpUnitDb(this.pumpUnitBox, this.pumpUnitNamesBox) {
    setupBox();
  }

  @override
  void deletePumpUnit(String key) {
    if (pumpUnitBox.length > 1) {
      pumpUnitBox.delete(key);
      pumpUnitNamesBox.delete(key);
    }
  }

  @override
  PumpUnit getFirstPumpUnit() {
    if (pumpUnitBox.isEmpty) throw Exception('Pump Unit Boxes is empty');
    return pumpUnitBox.values.first;
  }

  @override
  LinkedHashMap<String, String> getListOfPumpUnits() {
    return LinkedHashMap.from(pumpUnitNamesBox.toMap());
  }

  @override
  PumpUnit getPumpUnitWithKey(String key) {
    final pumpUnit = pumpUnitBox.get(key);
    if (pumpUnit == null) return getFirstPumpUnit();
    return pumpUnit;
  }

  @override
  void updateOrAddPumpUnit(String key, PumpUnit pumpUnit) {
    final pumpUnitToStore = pumpUnit;
    pumpUnitToStore.key = key;
    pumpUnitBox.put(key, pumpUnitToStore);
    pumpUnitNamesBox.put(key, pumpUnitToStore.name);
  }

  void setupBox() {
    if (pumpUnitBox.isEmpty) {
      final pumpUnit = PumpUnit.fromPumpCurve(
          pumpCurve: PumpCurve(rpm: 3600, points: pumpCurve), frequency: 50.0);
      pumpUnitBox.put(pumpUnit.key, pumpUnit);
      if (pumpUnitNamesBox.isEmpty) {
        pumpUnitNamesBox.put(pumpUnit.key, pumpUnit.name);
      }
    }
  }
}
