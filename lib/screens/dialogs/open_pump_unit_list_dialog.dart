import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:variable_speed_pump/screens/input_table/pump_curve_input_logic.dart';

Future<void> openPumpDialog({
  required BuildContext context,
  required Function(String) openFunction,
}) async {
  await showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      title: Text("Open the pump unit"),
      children: GetIt.I
          .get<PumpCurveInputLogic>()
          .pumpUnitNames
          .value
          .entries
          .map(
            (entry) => SimpleDialogOption(
              child: Text(entry.value),
              onPressed: () {
                openFunction(entry.key);
                Navigator.pop(context);
              },
            ),
          )
          .toList(),
    ),
  );
}
