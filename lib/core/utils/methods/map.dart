extension MapParseX on Map {
  T getValue<T>(String key, {required T defaultValue}) {
    final value = this[key];
    switch (value) {
      case T():
        return value;
      default:
        return defaultValue;
    }
  }


  T? getNullableValue<T>(
    String key, {
    T? defaultValue,
    T? Function(Object?)? parser,
  }) {
    final value = this[key];
    switch (value) {
      case T():
        return value;
      case null:
        return defaultValue;
      default:
        return parser?.call(value) ?? defaultValue;
    }
  }

  R getValueAs<T, R>(
    T key, {
    required R defaultValue,
    required R Function(T e) parseValue,
  }) {
    final value = this[key];
    switch (value) {
      case T():
        return parseValue(value);
      case R():
        return value;
      default:
        return defaultValue;
    }
  }

  List<T> getList<T>(
    String key, {
    required T Function(Object? e) parseItem,
  }) {
    final value = this[key];

    switch (value) {
      case List():
        final List<T> l = [];
        for (var e in value) {
          l.add(parseItem(e));
        }
        return l;
    }

    return <T>[];
  }

  List<T> getListIndex<T>(
    String key, {
    required T Function(Object? e, int index) parseItem,
  }) {
    final value = this[key];

    switch (value) {
      case List():
        final List<T> l = [];
        int i = 0;
        for (var e in value) {
          l.add(parseItem(e, i));
          i++;
        }
        return l;
    }

    return <T>[];
  }

  bool getBool(
    String key, {
    bool defaultValue = false,
  }) {
    return getValue<bool>(key, defaultValue: defaultValue);
  }

  int getInt(
    String key, {
    int defaultValue = 0,
  }) {
    final value = this[key];
    if (value == null) return defaultValue;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? defaultValue;
    return getValue<int>(key, defaultValue: defaultValue);
  }

  double getDouble(
    String key, {
    double defaultValue = 0.0,
  }) {
    final value = this[key];
    if (value == null) return defaultValue;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? defaultValue;
    return getValue<double>(key, defaultValue: defaultValue);
  }

  String getString(
    String key, {
    String defaultValue = '',
  }) {
    final value = this[key];
    if (value == null) return defaultValue;
    return value.toString();
  }

  Map<String, dynamic> getMap(
    String key, {
    Map<String, dynamic> defaultValue = const {},
  }) {
    final value = this[key];
    if (value == null) return defaultValue;
    if (value is Map<String, dynamic>) return value;
    return defaultValue;
  }
}

extension ObjectX on Object? {
  T parseMap<T>({
    required T Function(Map map) parser,
    required T defaultValue,
  }) {
    final object = this;
    switch (object) {
      case Map():
        return parser(object);
      default:
    }

    return defaultValue;
  }
}
