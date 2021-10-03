import 'package:flutter_test/flutter_test.dart';
import 'package:variable_speed_pump/screens/pump_curve/pump_curve_logic.dart';

void main() {
  late PowerPumpCurveLogic pcl;

  setUp(() {
    pcl = PowerPumpCurveLogic();
  });
  test('setup Min Max gets the pump curve points min and max head', () {
    pcl.setupMinMaxHead();
  });
}
