import 'package:new_my_app/utils/result.dart';

abstract class UserRepository {
  Future<Result<void>> saveUser(String user);
  Future<Result<String?>> getUser();
}