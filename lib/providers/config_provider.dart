
import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';

/// singleton class to provide the config
class ConfigProvider {
  static final ConfigProvider _instance = ConfigProvider._internal();

  factory ConfigProvider() => _instance;

  ConfigProvider._internal();

  late YamlMap _config;

  Future<void> loadConfig() async {
    final configString = await rootBundle.loadString('assets/cfg/config.yaml');
    _config = loadYaml(configString);
  }

  dynamic get(String key) => _config[key];
}