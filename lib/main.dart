import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:variable_speed_pump/screens/input_table/pump_curve_edit_table.dart';
import 'package:variable_speed_pump/screens/pump_curve/power_pump_curve_screen.dart';
import 'package:variable_speed_pump/screens/pump_curve/pump_curve_logic.dart';

import 'models/power_pump_curve.dart';
import 'setupApp.dart';

void main() {
  setupApp();
  runApp(MyHomePage());
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

//PumpCurveEditTable()

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.green,
              primaryColorDark: Colors.red,
              accentColor: Colors.amber)),
      routes: {
        PowerPumpCurveLoader.id: (context) => PowerPumpCurveLoader(),
        PumpCurveEditTable.id: (context) => PumpCurveEditTable(),
      },
      initialRoute: PumpCurveEditTable.id,
    );
  }
}

class PowerPumpCurveLoader extends StatelessWidget {
  const PowerPumpCurveLoader({
    Key? key,
  }) : super(key: key);
  static const String id = 'PowerPumpCurveLoader';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pump Unit Curve with Variable Power'),
      ),
      body: FutureBuilder(
          future: Future.delayed(Duration(seconds: 1)),
          builder: (context, snapshot) {
            //TODO: after testing remove this print
            print("${Timeline.now}, ${gi.isRegistered<PowerPumpCurveLogic>()}");
            if (gi.isRegistered<PowerPumpCurveLogic>() &&
                gi.isReadySync<PowerPumpCurveLogic>()) {
              return PowerPumpCurveBody();
            } else
              return Center(child: CircularProgressIndicator());
          }),
    );
  }
}

class PowerPumpCurveBody extends StatelessWidget {
  const PowerPumpCurveBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pumpCurveLogic = gi.get<PowerPumpCurveLogic>();

    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(right: 8),
              shrinkWrap: true,
              children: [
                Text(
                  'Pump Curves with Variable Power',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20.0),
                ),
                // PumpPowerCurveChart(),
                PUPowerCurveChart(),
                Container(
                  height: 150,
                  child: EfficiencyCurveChart(),
                ),
              ],
            ),
          ),
          ValueListenableBuilder<List<PowerPumpCurve>>(
            valueListenable: pumpCurveLogic.powerPumpCurves,
            builder: (context, powerPumpCurves, _) {
              final styleTitle =
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 12);
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 25, right: 25, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text('Min', style: styleTitle),
                              Text('${pumpCurveLogic.minHead} m'),
                            ],
                          ),
                          Column(
                            children: [
                              Text('Pump Head (TDH)', style: styleTitle),
                              Text('${powerPumpCurves[0].head} m'),
                            ],
                          ),
                          Column(
                            children: [
                              Text('Max', style: styleTitle),
                              Text('${pumpCurveLogic.maxHead} m'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Slider(
                        value: powerPumpCurves[0].head,
                        max: pumpCurveLogic.maxHead,
                        min: pumpCurveLogic.minHead,
                        onChanged: (newVal) =>
                            pumpCurveLogic.changeMainHead(newVal)),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
