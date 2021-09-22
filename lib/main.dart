import 'package:flutter/material.dart';
import 'package:variable_speed_pump/models/pump_curve/pump_curve_logic.dart';
import 'package:variable_speed_pump/syncfusion_line_chart.dart';

import 'models/get_it.dart';

void main() {
  setup();
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
        body: ListView(
          shrinkWrap: true,
          children: [
            Text(
              'Pump Curve Graphs',
              style: TextStyle(
                fontSize: 30.0,
              ),
            ),
            PumpPowerCurveChart(),
            TextButton(
                onPressed: () => gi<PumpCurveLogic>().changeHeadListTest(),
                child: Text("Change Me"))
            // LineChartSample2(),
            // GraphTest(),
            // LineChartSample1(),
          ],
        ),
      ),
    );
  }
}
