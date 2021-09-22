import 'package:get_it/get_it.dart';
import 'package:variable_speed_pump/models/pump_curve/pump_curve_logic.dart';

final GetIt gi = GetIt.I;

void setup() {
  gi.registerSingleton<PumpCurveLogic>(PumpCurveLogic());
}
