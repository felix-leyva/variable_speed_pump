import 'package:flutter/material.dart';

Future<void> savePUDialog({
  required BuildContext context,
  required Function(String) saveFunction,
}) async {
  await showDialog(
    context: context,
    builder: (context) {
      final textContr = TextEditingController();
      return SimpleDialog(
          title: Text("Duplicate pump unit and edit"),
          children: [
            Column(
              children: [
                TextField(
                  controller: textContr,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter name of the new pump unit'),
                ),
                TextButton(
                    onPressed: () {
                      saveFunction(textContr.value.text);
                      Navigator.pop(context);
                    },
                    child: Text('Create'))
              ],
            )
          ]);
    },
  );
}
