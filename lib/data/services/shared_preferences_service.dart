import 'package:logging/logging.dart';
import 'package:new_my_app/utils/result.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService{
  static const _userKey = 'user_key';
  static const _tokenKey = 'token_key';
  final _log = Logger('SharedPreferencesService');

  
  Future<Result<String?>> fetchUser() async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      _log.finer('Got user from SharedPreferences');
      return Result.ok(sharedPreferences.getString(_userKey));
    } on Exception catch (e) {
      _log.warning('Failed to get user', e);
      return Result.error(e);
    }
  }

  Future<Result<void>> saveUser(String? user) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      if (user == null) {
        _log.finer('Removed user');
        await sharedPreferences.remove(_userKey);
      } else {
        _log.finer('Replaced user');
        await sharedPreferences.setString(_userKey, user);
      }
      return const Result.ok(null);
    } on Exception catch (e) {
      _log.warning('Failed to set user', e);
      return Result.error(e);
    }
  }

  Future<Result<String?>> fetchToken() async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      _log.finer('Got token from SharedPreferences');
      return Result.ok(sharedPreferences.getString(_tokenKey));
    } on Exception catch (e) {
      _log.warning('Failed to get token', e);
      return Result.error(e);
    }
  }

  Future<Result<void>> saveToken(String? token) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      if (token == null) {
        _log.finer('Removed token');
        await sharedPreferences.remove(_tokenKey);
      } else {
        _log.finer('Replaced token');
        await sharedPreferences.setString(_tokenKey, token);
      }
      return const Result.ok(null);
    } on Exception catch (e) {
      _log.warning('Failed to set token', e);
      return Result.error(e);
    }
  }
}