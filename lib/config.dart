
class Config {
  static final Config _instance = Config._internal();
  late String baseUrl;
  // bool isLoaded = false;

  factory Config() {
    return _instance;
  }

  Config._internal();
}
