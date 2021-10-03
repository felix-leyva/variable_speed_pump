import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:variable_speed_pump/models/pump_unit/pump_unit.dart';
import 'package:variable_speed_pump/screens/input_table/pump_curve_input_logic.dart';

class PumpCurveNameInput extends StatelessWidget {
  const PumpCurveNameInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<PumpUnit>(
      valueListenable: GetIt.I.get<PumpCurveInputLogic>().pumpUnit,
      builder: (context, pumpUnit, _) => Row(
        children: [
          Flexible(
            child: TextField(
              controller: TextEditingController(text: pumpUnit.name),
              onChanged: (newName) => GetIt.I
                  .get<PumpCurveInputLogic>()
                  .changePumpUnitName(newName),
              decoration: InputDecoration(
                  labelText: 'Edit Pump Unit Name',
                  border: OutlineInputBorder()),
            ),
          ),
          Flexible(
            child: TextField(
              enabled: false,
              controller: TextEditingController(
                  text: '${pumpUnit.motor.powerkW.toInt().toString()} kW'),
              decoration: InputDecoration(
                labelText: 'Calculated motor power',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// 'PumpName: ${pumpUnit.name}'
