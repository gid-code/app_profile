import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_my_app/data/repositories/profile/profile_repository_remote.dart';
import 'package:new_my_app/data/repositories/user/user/user_repository_local.dart';
import 'package:new_my_app/data/services/api/models/update_profile_request/update_profile_request.dart';
import 'package:new_my_app/ui/account/account_viewmodel.dart';
import 'package:new_my_app/utils/result.dart';

class MockProfileRepository extends Mock implements ProfileRepositoryRemote {}

class MockUserRepository extends Mock implements UserRepositoryLocal {}

void main() {
  late AccountViewmodel viewModel;
  late MockProfileRepository mockProfileRepo;
  late MockUserRepository mockUserRepo;

  setUpAll(() {
    registerFallbackValue(const UpdateProfileRequest(
      firstName: 'Test',
      lastName: 'Test',
      address: 'Test'
    ));
  });

  setUp(() {
    mockProfileRepo = MockProfileRepository();
    mockUserRepo = MockUserRepository();

    // Set up default behaviors
    when(() => mockProfileRepo.saveProfile(any())).thenAnswer(
      (_) async => const Result.ok(null)
    );

    when(() => mockUserRepo.getUser()).thenAnswer(
      (_) async => Result.ok(jsonEncode({
        'firstName': 'John',
        'lastName': 'Doe',
        'phone': '1234567890',
        'address': 'Test Address'
      }))
    );

    when(() => mockUserRepo.saveUser(any())).thenAnswer(
      (_) async => const Result.ok(null)
    );

    viewModel = AccountViewmodel(
      profileRepository: mockProfileRepo,
      userRepository: mockUserRepo,
    );
  });

  group('load', () {
    test('should load and set user data when user exists', () async {
      await viewModel.load.execute();

      expect(viewModel.user?.firstName, equals('John'));
      expect(viewModel.user?.lastName, equals('Doe'));
      expect(viewModel.user?.phone, equals('1234567890'));
      expect(viewModel.user?.address, equals('Test Address'));
    });

    test('should create default user when no user exists', () async {
      when(() => mockUserRepo.getUser())
          .thenAnswer((_) async => const Result.ok(null));
      
      when(() => mockUserRepo.saveUser(any()))
          .thenAnswer((_) async => const Result.ok(null));

      await viewModel.load.execute();

      expect(viewModel.user?.firstName, equals('Jonathan'));
      expect(viewModel.user?.lastName, equals('Mensah'));
      expect(viewModel.user?.phone, equals('0241223456'));
      expect(viewModel.user?.address, equals('Accra'));
    });

    test('should handle error when loading user fails', () async {
      final testException = Exception('Failed to load user');
      when(() => mockUserRepo.getUser())
          .thenAnswer((_) async => Result.error(testException));

      viewModel = AccountViewmodel(
        profileRepository: mockProfileRepo,
        userRepository: mockUserRepo,
      );

      await viewModel.load.execute();

      expect(viewModel.load.error, isTrue);
      expect(viewModel.user, isNull);
    });
  });

  group('updateProfile', () {
    test('should update user profile successfully', () async {
      const request = UpdateProfileRequest(
        firstName: 'Jane',
        lastName: 'Smith',
        address: 'New Address'
      );

      when(() => mockProfileRepo.saveProfile(request))
          .thenAnswer((_) async => const Result.ok(null));
      
      when(() => mockUserRepo.saveUser(any()))
          .thenAnswer((_) async => const Result.ok(null));

      await viewModel.updateProfile.execute(request);

      verify(() => mockProfileRepo.saveProfile(request)).called(1);
      expect(viewModel.user?.firstName, equals('Jane'));
      expect(viewModel.user?.lastName, equals('Smith'));
      expect(viewModel.user?.address, equals('New Address'));
      expect(viewModel.updateProfile.error, isFalse);
      expect(viewModel.updateProfile.completed, isTrue);
    });

    test('should handle update profile failure', () async {
      const request = UpdateProfileRequest(
        firstName: 'Jane',
        lastName: 'Smith',
        address: 'New Address'
      );

      final testException = Exception('Update failed');
      when(() => mockProfileRepo.saveProfile(request))
          .thenAnswer((_) async => Result.error(testException));

      await viewModel.updateProfile.execute(request);

      expect(viewModel.updateProfile.error, isTrue);
      verify(() => mockProfileRepo.saveProfile(request)).called(1);
      verifyNever(() => mockUserRepo.saveUser(any()));
    });
  });
}