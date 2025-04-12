import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:new_my_app/data/repositories/profile/profile_repository.dart';
import 'package:new_my_app/data/repositories/user/user/user_repository.dart';
import 'package:new_my_app/data/services/api/models/update_profile_request/update_profile_request.dart';
import 'package:new_my_app/models/user/user.dart';
import 'package:new_my_app/utils/command.dart';

import '../../utils/result.dart';

class AccountViewmodel extends ChangeNotifier{
  AccountViewmodel({
    required ProfileRepository profileRepository,
    required UserRepository userRepository
  }) : _profileRepository = profileRepository,
      _userRepository = userRepository{
        load = Command0(_load)..execute();
        updateProfile = Command1(_updateProfile);
      }

  final UserRepository _userRepository;
  final ProfileRepository _profileRepository;
  final _log = Logger('AccountViewmodel');
  User? _user;

  late Command0 load;
  late Command1<void, UpdateProfileRequest> updateProfile;

  User? get user => _user;

  Future<Result> _load() async {
    try {

      final userResult = await _userRepository.getUser();
      switch (userResult) {
        case Ok<String?>():
          if (userResult.value == null) {
            var newUser = const User(firstName: "Jonathan", lastName: "Mensah", phone: "0241223456", address: "Accra");
            final saveResult = await _userRepository.saveUser(jsonEncode(newUser.toJson()));
            switch (saveResult) {
              case Ok():
                _user = newUser;
                _log.fine('Saved user');
                break;
              case Error<void>():
                _log.warning('Failed to save user', saveResult.error);
            }
            break;
          }else{
            _user = User.fromJson(jsonDecode(userResult.value!));
            _log.fine('Loaded user');
          }
        case Error<String?>():
          _log.warning('Failed to load user', userResult.error);
      }

      return userResult;
    } finally {
      notifyListeners();
    }
  }

  Future<Result> _updateProfile(UpdateProfileRequest request) async {
    try {
      final result = await _profileRepository.saveProfile(request);
      switch (result) {
        case Ok<void>():
          var newUser = _user?.copyWith(
            firstName: request.firstName,
            lastName: request.lastName,
            address: request.address,
          );
          if(newUser != null) await _userRepository.saveUser(jsonEncode(newUser.toJson()));
          _user = newUser;
          _log.fine('Updated user');
          break;
        case Error<void>():
          _log.warning('Failed to update user', result.error);
      }
      return result;
    } finally {
      notifyListeners();
    }
  }
}