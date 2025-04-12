import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_my_app/data/repositories/profile/profile_repository_remote.dart';
import 'package:new_my_app/data/services/api/api_client.dart';
import 'package:new_my_app/data/services/api/models/update_profile_request/update_profile_request.dart';
import 'package:new_my_app/utils/result.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late ProfileRepositoryRemote repository;
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
    repository = ProfileRepositoryRemote(apiClient: mockApiClient);
    
    registerFallbackValue(
      const UpdateProfileRequest(
        firstName: 'Test',
        lastName: 'User',
        address: 'Test Address',
      ),
    );
  });

  group('saveProfile', () {
    test('should successfully update profile', () async {
      const request = UpdateProfileRequest(
        firstName: 'John',
        lastName: 'Doe',
        address: 'Test Address',
      );

      when(() => mockApiClient.updateProfile(any()))
          .thenAnswer((_) async => const Result.ok(null));

      final result = await repository.saveProfile(request);

      expect(result, isA<Result<void>>());
      verify(() => mockApiClient.updateProfile(request)).called(1);
    });

    test('should handle error when updating profile fails', () async {
      const request = UpdateProfileRequest(
        firstName: 'John',
        lastName: 'Doe',
        address: 'Test Address',
      );

      const testException = HttpException('Update failed');
      when(() => mockApiClient.updateProfile(any()))
          .thenAnswer((_) async => const Result.error(testException));

      final result = await repository.saveProfile(request);
      
      expect(result, isA<Error<void>>());
      expect((result as Error).error, equals(testException));
      verify(() => mockApiClient.updateProfile(request)).called(1);
    });
  });
}