import 'package:new_my_app/data/repositories/profile/profile_repository.dart';
import 'package:new_my_app/data/services/api/api_client.dart';
import 'package:new_my_app/data/services/api/models/update_profile_request/update_profile_request.dart';
import 'package:new_my_app/utils/result.dart';

class ProfileRepositoryRemote implements ProfileRepository{
  ProfileRepositoryRemote({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<Result<void>> saveProfile(UpdateProfileRequest request) async{
    final result = await _apiClient.updateProfile(request);
    switch (result) {
      case Ok():
        return const Result.ok(null);
      case Error():
        return Result.error(result.error);
    }
  }

}