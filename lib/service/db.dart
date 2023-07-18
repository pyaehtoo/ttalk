import 'dart:convert';

import 'package:hive_flutter/adapters.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teatalk/model/user_profile.dart';
import 'package:teatalk/service/db_keys.dart';
import 'package:teatalk/util/constant.dart';

class DbService {
  static DbService? _instance;

  static DbService get instance => _instance ??= DbService();
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  final box = Hive.box(BoxNameApp);

  DbService();

  Future<void> saveString(String key, String value) async {
    return box.put(key, value);
    // final prefs = await _pref;
    // return await prefs.setString(key, value);
  }

  Future<String?> grabString(String key) async {
    return box.get(key);
    // final prefs = await _pref;
    // return prefs.getString(key);
  }

   Future<void> saveDouble(String key, double value) async {
    return box.put(key, value);
    // final prefs = await _pref;
    // return await prefs.setDouble(key, value);
  }

  Future<double?> grabDouble(String key) async {
    return box.get(key);
    // final prefs = await _pref;
    // return prefs.getDouble(key);
  }

  Future<void> saveBool(String key, bool value) async {
    return box.put(key, value);
    // final prefs = await _pref;
    // return await prefs.setBool(key, value);
  }

  Future<bool?> grabBool(String key) async {
    return box.get(key);
    // final prefs = await _pref;
    // return prefs.getBool(key);
  }

  Future<void> saveInt(String key, int value) async {
    return box.put(key, value);
    // final prefs = await _pref;
    // return await prefs.setInt(key, value);
  }

  Future<int?> grabInt(String key) async {
    return box.get(key);
    // final prefs = await _pref;
    // return prefs.getInt(key);
  }

  Future logout() async {
    return box.delete(kAuthPref);
    // final prefs = await _pref;
    // return await prefs.remove(kAuthPref);
  }

  Future<void> saveLoggedInUser(UserProfileModel userProfileModel) async {
    // final prefs = await _pref;
    String user = jsonEncode(userProfileModel.toJson());
    return box.put(keyLoggedInUser, user);
    // return await prefs.setString(keyLoggedInUser, user);
  }

  Future<UserProfileModel?> getLoggedInUser() async {
    // final prefs = await _pref;
    // String jsonString = prefs.getString(keyLoggedInUser) ?? '';
    String jsonString = box.get(keyLoggedInUser) ?? '';
    if (jsonString.isNotEmpty) {
      Map<String, dynamic> json =
          jsonDecode(jsonString) as Map<String, dynamic>;
      return UserProfileModel.fromJson(json);
    } else {
      return null;
    }
  }
}
