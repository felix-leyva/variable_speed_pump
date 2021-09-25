import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:variable_speed_pump/syncfusion_line_chart.dart';

import 'models/power_pump_curve.dart';
import 'models/pump_curve/pump_curve_logic.dart';
import 'models/setupApp.dart';

void main() {
  setupApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Graph test'),
        ),
        body: PowerPumpCurveLoader(),
      ),
    );
  }
}

class PowerPumpCurveLoader extends StatelessWidget {
  const PowerPumpCurveLoader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.delayed(Duration(seconds: 1)),
        builder: (context, snapshot) {
          //TODO: after testing remove this print
          print("${Timeline.now}, ${gi.isRegistered<PowerPumpCurveLogic>()}");
          if (gi.isRegistered<PowerPumpCurveLogic>() &&
              gi.isReadySync<PowerPumpCurveLogic>()) {
            return PowerPumpCurveBody();
          } else
            return Center(child: CircularProgressIndicator());
        });
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
