import 'package:new_my_app/data/repositories/user/user/user_repository.dart';
import 'package:new_my_app/data/services/shared_preferences_service.dart';
import 'package:new_my_app/utils/result.dart';

class UserRepositoryLocal implements UserRepository {
  UserRepositoryLocal({required SharedPreferencesService sharedPreferencesService})
      : _sharedPreferencesService = sharedPreferencesService;

  final SharedPreferencesService _sharedPreferencesService;

  @override
  Future<Result<String?>> getUser() async{
   return  _sharedPreferencesService.fetchUser();
  }

  @override
  Future<Result<void>> saveUser(String user) async{
    return _sharedPreferencesService.saveUser(user);
  }
}