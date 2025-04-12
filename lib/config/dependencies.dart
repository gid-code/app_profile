import 'package:new_my_app/data/repositories/profile/profile_repository.dart';
import 'package:new_my_app/data/repositories/profile/profile_repository_remote.dart';
import 'package:new_my_app/data/repositories/user/user/user_repository.dart';
import 'package:new_my_app/data/repositories/user/user/user_repository_local.dart';
import 'package:new_my_app/data/services/shared_preferences_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:new_my_app/data/services/api/api_client.dart';

List<SingleChildWidget> providers = [
  Provider(create: (context) => ApiClient()),
  Provider(create: (context) => SharedPreferencesService()),
  Provider(
    create:
        (context) =>
            UserRepositoryLocal(sharedPreferencesService: context.read()) as UserRepository,
  ),
  Provider(
    create: (context) => ProfileRepositoryRemote(apiClient: context.read()) as ProfileRepository,
  ),
];