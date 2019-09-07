import 'package:logging/logging.dart';

import '../project_config.dart';

abstract class ConfigCache {
  final Logger logger = Logger('ConfigCache');
  ProjectConfig _inMemoryValue;

  ConfigCache();

  /// Child classes has to implement this method, the {@link ConfigCatClient}
  /// uses it to get the actual value from the cache.
  ///
  /// @return the cached configuration.
  /// @throws Exception if unable to read the cache.
  ProjectConfig read();

  /// * Child classes has to implement this method, the {@link ConfigCatClient}
  /// uses it to set the actual cached value.
  ///
  /// @param value the new value to cache.
  /// @throws Exception if unable to save the value.
  void write(ProjectConfig value);

  /// Through this getter, the in-memory representation of the cached value can be accessed.
  /// When the underlying cache implementations is not able to load or store its value,
  /// this will represent the latest cached configuration.
  ///
  /// @return the cached value in memory.
  ProjectConfig inMemoryValue() {
    return this._inMemoryValue;
  }

  ProjectConfig get() {
    try {
      return this.read();
    } catch (e) {
      print("An error occurred during the cache read");
      return this._inMemoryValue;
    }
  }

  void set(ProjectConfig value) {
    try {
      this._inMemoryValue = value;
      this.write(value);
    } catch (e) {
      print("An error occurred during the cache write");
    }
  }
}

class InMemoryConfigCache extends ConfigCache {
  @override
  ProjectConfig read() {
    return super.inMemoryValue();
  }

  @override
  void write(ProjectConfig value) {}
}
