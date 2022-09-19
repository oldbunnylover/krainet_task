import 'package:krainet_task/data/data_sources/interfaces/i_preference_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceDataSource implements IPreferenceDataSource {
  static const _userIdPref = 'user_id';

  Future<SharedPreferences> get _prefs async {
    return await SharedPreferences.getInstance();
  }

  @override
  void clearUserId() {
    _prefs.then((prefs) => prefs.remove(_userIdPref));
  }

  @override
  Future<String?> getUserId() {
    return _prefs.then((prefs) => prefs.getString(_userIdPref));
  }

  @override
  void saveUserId(String id) {
    _prefs.then((prefs) => prefs.setString(_userIdPref, id));
  }
}