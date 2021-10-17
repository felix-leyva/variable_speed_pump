import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:variable_speed_pump/models/pump_unit/pump_unit.dart';
import 'package:variable_speed_pump/screens/input_table/pump_curve_input_logic.dart';

class PumpCurveNameInput extends StatefulWidget {
  const PumpCurveNameInput({Key? key}) : super(key: key);

  @override
  State<PumpCurveNameInput> createState() => _PumpCurveNameInputState();
}

class _PumpCurveNameInputState extends State<PumpCurveNameInput> {
  int pumpNameCursorPos = 0;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<PumpUnit>(
      valueListenable: GetIt.I.get<PumpCurveInputLogic>().pumpUnit,
      builder: (context, pumpUnit, _) {
        TextEditingController nameTC =
            TextEditingController(text: pumpUnit.name);

        //keep cursor position when changing name value
        if (pumpNameCursorPos <= pumpUnit.name.length) {
          nameTC.selection = TextSelection.fromPosition(
              TextPosition(offset: pumpNameCursorPos));
        }

        return Row(
          children: [
            Flexible(
              child: TextField(
                controller: nameTC,
                onChanged: (newName) {
                  pumpNameCursorPos = nameTC.selection.baseOffset;
                  GetIt.I
                      .get<PumpCurveInputLogic>()
                      .changePumpUnitName(newName);
                },
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
        );
      },
    );
  }
}
