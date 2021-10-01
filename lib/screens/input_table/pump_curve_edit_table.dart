import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:variable_speed_pump/screens/input_table/pump_curve_input_logic.dart';
import 'package:variable_speed_pump/utils/functions.dart';

import '../../setupApp.dart';

class PumpCurveEditTable extends StatelessWidget {
  const PumpCurveEditTable({Key? key}) : super(key: key);
  static const id = 'PumpCurveEditTable';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Pump Curve'),
      ),
      body: FutureBuilder(
          future: Future.delayed(Duration(seconds: 1)),
          builder: (context, snapshot) {
            if (gi.isRegistered<PumpCurveInputLogic>() &&
                gi.isReadySync<PumpCurveInputLogic>()) {
              return PumpCurveInputList();
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}

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
              return Text('first row');
            } else {
              return RowFromListBuilder(index: objectIndex, inputs: inputs);
            }
          },
          itemCount: inputs.length + 1,
        ),
      ),
    );
  }
}

class RowFromListBuilder extends StatefulWidget {
  const RowFromListBuilder({
    Key? key,
    required this.index,
    required this.inputs,
  }) : super(key: key);

  final int index;
  final List<PumpCurvePointInput> inputs;

  @override
  State<RowFromListBuilder> createState() => _RowFromListBuilderState();
}

class _RowFromListBuilderState extends State<RowFromListBuilder> {
  Timer? _debounce;
  late final int index;
  late final TextEditingController c1;
  late final TextEditingController c2;
  late final TextEditingController c3;
  late final void Function(String, int) textChanged;
  late final List<PumpCurvePointInput> inputs;

  @override
  void initState() {
    index = widget.index;
    inputs = widget.inputs;

    c1 = TextEditingController(text: inputs[index].flow.roundD(1).toString());
    c2 = TextEditingController(text: inputs[index].head.roundD(1).toString());
    c3 = TextEditingController(
        text: inputs[index].efficiencyOrPower.roundD(1).toString());

    //TODO: move this logic to a function in a controller class
    textChanged = (text, pos) {
      if (_debounce?.isActive ?? false) _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 1000), () {
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
        print('Changed in $index pos: $pos with text $text');
      });
    };
    super.initState();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ColumnInputField(
            textChanged: (text) => textChanged(text, 1), controller: c1),
        ColumnInputField(
            textChanged: (text) => textChanged(text, 2), controller: c2),
        ColumnInputField(
            textChanged: (text) => textChanged(text, 3), controller: c3),
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

// List<PumpCurvePointInput> inputs = [
//   PumpCurvePointInput(flow: 113.58, head: 60, efficiencyOrPower: 0.6),
//   PumpCurvePointInput(flow: 170.38, head: 59.44, efficiencyOrPower: 0.72),
//   PumpCurvePointInput(flow: 227.17, head: 57.00, efficiencyOrPower: 0.8),
//   PumpCurvePointInput(flow: 283.96, head: 54.25, efficiencyOrPower: 0.84),
// ];
