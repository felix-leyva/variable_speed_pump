import 'package:hive/hive.dart';
import 'package:variable_speed_pump/utils/constants.dart';

import '../pump_curve_point.dart';

abstract class PumpCurvesSources {
  List<String> getListOfPumpCurves();
  List<PumpCurvePoint> getPumpCurves(String? name);
  void putPumpCurve(String name, List<PumpCurvePoint> pumpCurvePoints);
  void deletePumpCurve(String name);
}

class PumpCurvesDB extends PumpCurvesSources {
  Box<List> pumpCurvesBox;

  PumpCurvesDB(this.pumpCurvesBox) {
    setupBox();
  }

  void setupBox() async {
    if (pumpCurvesBox.isEmpty) {
      pumpCurvesBox.put(defaultPumpCurveName, pumpCurve);
    }
  }

  @override
  List<String> getListOfPumpCurves() =>
      pumpCurvesBox.keys.map((key) => key.toString()).toList();

  @override
  List<PumpCurvePoint> getPumpCurves(String? name) {
    if (name == null) {
      var _tmpCurve = pumpCurvesBox.get(defaultPumpCurveName) ?? [];
      var firstPumpCurveInBox = _tmpCurve.cast<PumpCurvePoint>();
      return firstPumpCurveInBox;
    }
    var tmpNamedCurve = pumpCurvesBox.get(name) ?? [];
    return tmpNamedCurve.cast<PumpCurvePoint>();
  }

  @override
  void putPumpCurve(String name, List<PumpCurvePoint> pumpCurvePoints) {
    pumpCurvesBox.put(name, pumpCurvePoints);
  }

  @override
  void deletePumpCurve(String name) {
    if (pumpCurvesBox.length > 1) pumpCurvesBox.delete(name);
  }
}
