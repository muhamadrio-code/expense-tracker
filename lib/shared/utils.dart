// ignore: camel_case_types
T requireNotNull<T>(T? value, [String? name]) =>
    ArgumentError.checkNotNull(value, name);
