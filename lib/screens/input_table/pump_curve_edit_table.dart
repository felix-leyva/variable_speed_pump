import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:variable_speed_pump/screens/input_table/pump_curve_input_logic.dart';
import 'package:variable_speed_pump/utils/functions.dart';

class PumpCurveInputList extends StatelessWidget {
  const PumpCurveInputList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ValueListenableBuilder<List<PumpCurvePointInput>>(
        valueListenable:
            GetIt.I.get<PumpCurveInputLogic>().pumpCurvePointInputs,
        builder: (context, inputs, _) => ListView.builder(
          itemBuilder: (_, index) {
            final objectIndex = index - 1;
            if (objectIndex == -1) {
              return NamesRow();
            } else {
              return PumpPointInputRow(index: objectIndex, inputs: inputs);
            }
          },
          itemCount: inputs.length + 1,
        ),
      ),
    );
  }
}

class NamesRow extends StatelessWidget {
  const NamesRow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
          fit: FlexFit.tight,
          child: Text(
            'Flow (m3/h)',
            textAlign: TextAlign.center,
          ),
        ),
        Flexible(
          fit: FlexFit.tight,
          child: Text(
            'Head (m)',
            textAlign: TextAlign.center,
          ),
        ),
        Flexible(
          fit: FlexFit.tight,
          child: Text(
            'Efficiency (%)',
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class PumpPointInputRow extends StatelessWidget {
  const PumpPointInputRow({
    Key? key,
    required this.index,
    required this.inputs,
  }) : super(key: key);

  final int index;
  final List<PumpCurvePointInput> inputs;

  @override
  Widget build(BuildContext context) {
    final void Function(String, int) textChanged = (text, pos) {
      double? numericValue = double.tryParse(text);
      if (numericValue == null) {
        return;
      } else if (pos == 1) {
        GetIt.I.get<PumpCurveInputLogic>().updateFlow(index, numericValue);
      } else if (pos == 2) {
        GetIt.I.get<PumpCurveInputLogic>().updateHead(index, numericValue);
      } else if (pos == 3) {
        GetIt.I
            .get<PumpCurveInputLogic>()
            .updateEffOrPower(index, numericValue);
      }
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ColumnInputField(
          textChanged: (text) => textChanged(text, 1),
          controller: TextEditingController(
              text: inputs[index].flow.roundD(1).toString()),
        ),
        ColumnInputField(
          textChanged: (text) => textChanged(text, 2),
          controller: TextEditingController(
              text: inputs[index].head.roundD(1).toString()),
        ),
        ColumnInputField(
          textChanged: (text) => textChanged(text, 3),
          controller: TextEditingController(
              text: inputs[index].efficiencyOrPower.roundD(1).toString()),
        ),
      ],
    );
  }
}

class ColumnInputField extends StatelessWidget {
  const ColumnInputField({
    Key? key,
    required this.textChanged,
    required this.controller,
  }) : super(key: key);

  final void Function(String text) textChanged;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(0)),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 9),
          isDense: true,
        ),
        textAlign: TextAlign.center,
        inputFormatters: [
          DecimalTextInputFormatter(
              activatedNegativeValues: false, decimalRange: 2)
        ],
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        onChanged: textChanged,
        controller: controller,
      ),
    );
  }
}

class PumpCurvePointInput {
  double flow;
  double head;
  double efficiencyOrPower;
  PumpCurvePointInput(
      {required this.flow,
      required this.head,
      required this.efficiencyOrPower});
}
