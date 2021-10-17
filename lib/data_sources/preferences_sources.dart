import 'package:hive/hive.dart';

abstract class PreferencesSource {
  String? getCurrentPUKey();
  void setCurrentPUKey(String newKey);
  Stream<BoxEvent> listenCurrentPUKey();
}

class PreferencesDb extends PreferencesSource {
  static const boxName = 'preferences_box';
  Box<String> _preferencesBox;
  PreferencesDb(this._preferencesBox);

  @override
  String? getCurrentPUKey() {
    return _preferencesBox.get(Preferences.lastOpenKey.toString());
  }

  @override
  void setCurrentPUKey(String newKey) {
    _preferencesBox.put(Preferences.lastOpenKey.toString(), newKey);
  }

  @override
  Stream<BoxEvent> listenCurrentPUKey() {
    return _preferencesBox.watch(key: Preferences.lastOpenKey.toString());
  }
}

enum Preferences {
  lastOpenKey,
}
