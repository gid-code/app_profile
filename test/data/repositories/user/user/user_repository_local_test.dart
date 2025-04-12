import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_my_app/data/repositories/user/user/user_repository_local.dart';
import 'package:new_my_app/data/services/shared_preferences_service.dart';
import 'package:new_my_app/utils/result.dart';

class MockSharedPreferencesService extends Mock implements SharedPreferencesService {}

void main() {
  late UserRepositoryLocal repository;
  late MockSharedPreferencesService mockPrefs;

  setUp(() {
    mockPrefs = MockSharedPreferencesService();
    repository = UserRepositoryLocal(sharedPreferencesService: mockPrefs);
  });

  group('getUser', () {
    test('should return user data from shared preferences', () async {
      const userData = '{"firstName":"John","lastName":"Doe"}';
      when(() => mockPrefs.fetchUser())
          .thenAnswer((_) async => const Result.ok(userData));

      final result = await repository.getUser();

      expect(result, isA<Result<String?>>());
      verify(() => mockPrefs.fetchUser()).called(1);
    });

    test('should handle error when fetching user fails', () async {
      final testException = Exception('Failed to fetch user');
      when(() => mockPrefs.fetchUser())
          .thenAnswer((_) async => Result.error(testException));

      final result = await repository.getUser();

      expect(result, isA<Error<String?>>());
      expect((result as Error).error, equals(testException));
      verify(() => mockPrefs.fetchUser()).called(1);
    });
  });

  group('saveUser', () {
    test('should save user data to shared preferences', () async {
      const userData = '{"firstName":"John","lastName":"Doe"}';
      when(() => mockPrefs.saveUser(userData))
          .thenAnswer((_) async => const Result.ok(null));

      await repository.saveUser(userData);

      verify(() => mockPrefs.saveUser(userData)).called(1);
    });

    test('should handle error when saving user fails', () async {
      const userData = '{"firstName":"John","lastName":"Doe"}';
      final testException = Exception('Failed to save user');
      when(() => mockPrefs.saveUser(userData))
          .thenAnswer((_) async => Result.error(testException));

      final result = await repository.saveUser(userData);

      expect(result, isA<Error<void>>());
      expect((result as Error).error, equals(testException));
      verify(() => mockPrefs.saveUser(userData)).called(1);
    });
  });
}