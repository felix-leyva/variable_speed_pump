import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Future<void> openPumpDialog({
  required BuildContext context,
  required Function(String) openFunction,
  required LinkedHashMap<String, String> pumpUnitNames,
}) async {
  await showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      title: Text("Open the pump unit"),
      children: pumpUnitNames.entries
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
