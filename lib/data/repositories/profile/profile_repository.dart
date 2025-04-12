import 'package:new_my_app/data/services/api/models/update_profile_request/update_profile_request.dart';
import 'package:new_my_app/utils/result.dart';

abstract class ProfileRepository {
  Future<Result<void>> saveProfile(UpdateProfileRequest request);
}