abstract class IPreferenceDataSource {
  Future<String?> getUserId();
  void clearUserId();
  void saveUserId(String id);
}