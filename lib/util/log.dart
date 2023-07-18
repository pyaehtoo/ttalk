import 'package:flutter/foundation.dart';

class Log {
  static void d(Object object) {
    if (kDebugMode) print(object);
  }
}
