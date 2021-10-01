import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:variable_speed_pump/data_sources/pump_unit_sources.dart';
import 'package:variable_speed_pump/models/motor/motor.dart';
import 'package:variable_speed_pump/models/pump_curve/pump_curve.dart';
import 'package:variable_speed_pump/models/pump_curve_points/pump_curve_point.dart';
import 'package:variable_speed_pump/models/pump_unit/pump_unit.dart';
import 'package:variable_speed_pump/models/pump_unit_curve_point/pump_unit_curve_point.dart';
import 'package:variable_speed_pump/screens/input_table/pump_curve_edit_table.dart';

class PumpCurveInputLogic {
  late final PumpUnitSource source;
  late PumpUnit pumpUnit; //as parameter due we need to access motor later

  ValueNotifier<bool> editEff = ValueNotifier(true);
  String currentKey = '';

  late ValueNotifier<List<PumpCurvePointInput>> pumpCurvePointInputs;

  ValueNotifier<LinkedHashMap<String, String>> pumpUnitNames =
      ValueNotifier(LinkedHashMap());

  PumpCurveInputLogic({
    PumpUnitSource? source,
    String? pumpUnitKey,
    PumpUnit? startingPumpUnit,
  }) {
    this.source = source ?? GetIt.I.get<PumpUnitSource>();
    if (startingPumpUnit != null) {
      pumpUnit = startingPumpUnit;
    } else if (pumpUnitKey != null) {
      pumpUnit = this.source.getPumpUnitWithKey(pumpUnitKey);
    } else {
      pumpUnit = this.source.getFirstPumpUnit();
    }

    pumpUnitNames.value = this.source.getListOfPumpUnits();
    currentKey = pumpUnit.key;
    pumpCurvePointInputs = ValueNotifier(pumpCurvePointInputsFromPumpUnit(
      pumpUnit: pumpUnit,
      useEfficiency: editEff.value,
    ));
  }

  void toggleEditCurveEfficiencyPower() {
    editEff.value = !editEff.value;
  }

  void updateFlow(int pointIndex, double newFlow) {
    //TODO: add validation considering previous and next points
    pumpCurvePointInputs.value[pointIndex].flow = newFlow;
    savePumpUnitIntoDataSource();
  }

  void updateHead(int pointIndex, double newHead) {
    //TODO: add validation considering previous and next points
    pumpCurvePointInputs.value[pointIndex].head = newHead;
    savePumpUnitIntoDataSource();
  }

  void updateEffOrPower(int pointIndex, double newValue) {
    //TODO: add validation considering previous and next points
    if (editEff.value) {
      pumpCurvePointInputs.value[pointIndex].efficiencyOrPower = newValue;
    } else {
      //TODO: estimate eff from power value
      // pumpCurvePointInputs.value[pointIndex].efficiencyOrPower = newValue;
    }
    savePumpUnitIntoDataSource();
  }

  void savePumpUnitIntoDataSource() {
    updatePumpUnitFromCurvePoints();
    source.updateOrAddPumpUnit(currentKey, pumpUnit);
    updateValueNotifiers();
  }

  void updateValueNotifiers() {
    pumpUnit = source.getPumpUnitWithKey(currentKey);
    pumpUnitNames.value = this.source.getListOfPumpUnits();
  }

  void deleteCurrentPumpUnit() {
    if (pumpUnitNames.value.length > 1) source.deletePumpUnit(currentKey);
    currentKey = pumpUnitNames.value.keys.first;
    updateValueNotifiers();
  }

  List<PumpCurvePointInput> pumpCurvePointInputsFromPumpUnit(
      {required PumpUnit pumpUnit, required bool useEfficiency}) {
    List<PumpCurvePointInput> pumpCurveInput;

    if (useEfficiency) {
      pumpCurveInput = pumpUnit.pumpCurve.points
          .map((point) => PumpCurvePointInput(
              flow: point.flow,
              head: point.head,
              efficiencyOrPower: point.pumpEndEff * 100))
          .toList();
    } else {
      pumpCurveInput = pumpUnit.pumpCurve.points.map((point) {
        final pumpCurvePoint =
            PumpUnitCurvePoint(pumpCurvePoint: point, motor: pumpUnit.motor);

        return PumpCurvePointInput(
            flow: point.flow,
            head: point.head,
            efficiencyOrPower: pumpCurvePoint.requiredkW);
      }).toList();
    }
    return pumpCurveInput;
  }

  void updatePumpUnitFromCurvePoints() {
    PumpCurve pumpCurve;
    if (editEff.value) {
      final double rpm = 3600;
      //Obtener motor, RPM, Hz - crear una PU
      pumpCurve = PumpCurve(
        rpm: rpm,
        points: pumpCurvePointInputs.value
            .map((point) => PumpCurvePoint.withEfficiency(
                  rpm: rpm,
                  pumpEndEff: point.efficiencyOrPower / 100,
                  head: point.head,
                  flow: point.flow,
                ))
            .toList(),
      );
    } else {
      //TODO: estimate the required motor
      pumpCurve = pumpUnit.pumpCurve;
    }

    Motor newMotor = Motor(pumpCurve.getMotorPowerSegment());
    print('Motor power ${newMotor.powerkW}');
    this.pumpUnit = pumpUnit.copyWith(pumpCurve: pumpCurve, motor: newMotor);
  }
}
