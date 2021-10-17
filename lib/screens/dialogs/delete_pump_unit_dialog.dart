import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> deletePumpUnitDialog({
  required BuildContext context,
  required Function() deleteFunction,
}) async {
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Delete the current pump unit'),
        content: Text(
            'Do you wish to delete the active pump unit? This action cannot be reversed!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              deleteFunction();
              Navigator.pop(context);
            },
            child: Text('ACCEPT'),
          ),
        ],
      );
    },
  );
}
