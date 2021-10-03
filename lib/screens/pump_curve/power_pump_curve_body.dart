import 'package:flutter/material.dart';
import 'package:variable_speed_pump/models/power_pump_unit_curve.dart';
import 'package:variable_speed_pump/screens/pump_curve/power_pump_curve_screen.dart';
import 'package:variable_speed_pump/screens/pump_curve/pump_curve_logic.dart';

import '../../setupApp.dart';

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
          ValueListenableBuilder<List<PowerPumpUnitCurve>>(
            valueListenable: pumpCurveLogic.powerPUCurves,
            builder: (context, powerPUCurves, _) {
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
                              Text('${powerPUCurves[0].head} m'),
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
                        value: powerPUCurves[0].head,
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
