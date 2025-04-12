import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_my_app/data/repositories/profile/profile_repository_remote.dart';
import 'package:new_my_app/data/repositories/user/user/user_repository_local.dart';
import 'package:new_my_app/data/services/api/models/update_profile_request/update_profile_request.dart';
import 'package:new_my_app/models/user/user.dart';
import 'package:new_my_app/ui/account/account_viewmodel.dart';
import 'package:new_my_app/ui/account/profile/update_profile_screen.dart';
import 'package:new_my_app/utils/command.dart';
import 'package:new_my_app/utils/result.dart';

class MockAccountViewModel extends ChangeNotifier implements AccountViewmodel {
  @override
  User? get user => _user;
  User? _user;
  
  void setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  @override
  late final Command0 load;

  @override
  late final Command1<void, UpdateProfileRequest> updateProfile;
}

class MockProfileRepository extends Mock implements ProfileRepositoryRemote {}

class MockUserRepository extends Mock implements UserRepositoryLocal {}

class MockCommand0 extends Mock implements Command0 {}

class MockCommand1<T, A> extends Mock implements Command1<T, A> {}

void main() {
  late MockAccountViewModel mockViewModel;
  late MockProfileRepository mockProfileRepo;
  late MockUserRepository mockUserRepo;
  late MockCommand1<void, UpdateProfileRequest> updateProfileCommand;
  late MockCommand0 loadCommand;

  setUpAll(() {
    registerFallbackValue(const UpdateProfileRequest(
      firstName: 'Test',
      lastName: 'Test',
      address: 'Test'
    ));
  });

  setUp(() {
    mockViewModel = MockAccountViewModel();
    mockProfileRepo = MockProfileRepository();
    mockUserRepo = MockUserRepository();
    updateProfileCommand = MockCommand1<void, UpdateProfileRequest>();
    loadCommand = MockCommand0();

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

    // Set up default behaviors for commands
    when(() => updateProfileCommand.running).thenReturn(false);
    when(() => updateProfileCommand.error).thenReturn(false);
    when(() => updateProfileCommand.completed).thenReturn(false);
    when(() => updateProfileCommand.execute(any())).thenAnswer(
      (_) async => const Result.ok(null)
    );

    when(() => loadCommand.running).thenReturn(false);
    when(() => loadCommand.error).thenReturn(false);
    when(() => loadCommand.completed).thenReturn(false);
    when(() => loadCommand.execute()).thenAnswer(
      (_) async {
        mockViewModel.setUser(const User(
          firstName: 'John',
          lastName: 'Doe',
          address: 'Test Address',
          phone: '1234567890'
        ));
        return Future.value(Result.ok(null));
      }
    );

    // Set up default behaviors
    when(() => mockProfileRepo.saveProfile(any())).thenAnswer(
      (_) async => const Result.ok(null)
    );

    mockViewModel.updateProfile = updateProfileCommand;
    mockViewModel.load = loadCommand;
  });

  testWidgets('UpdateProfileScreen shows form fields with initial values', (WidgetTester tester) async {
    when(() => loadCommand.completed).thenReturn(true);

    const user = User(
      firstName: 'John',
      lastName: 'Doe',
      address: 'Test Address',
      phone: '1234567890'
    );
    
    mockViewModel.setUser(user);
    await mockViewModel.load.execute();

    await tester.pumpWidget(MaterialApp(
      home: UpdateProfileScreen(viewModel: mockViewModel),
    ));

    await tester.pumpAndSettle();


    // Find RichText widgets for field labels
    final firstNameRichText = find.byWidgetPredicate((widget) => 
      widget is RichText && 
      widget.text.toPlainText() == 'First Name *'
    );
    expect(firstNameRichText, findsOneWidget);

    final lastNameRichText = find.byWidgetPredicate((widget) => 
      widget is RichText && 
      widget.text.toPlainText() == 'Last Name *'
    );
    expect(lastNameRichText, findsOneWidget);

    final addressRichText = find.byWidgetPredicate((widget) => 
      widget is RichText && 
      widget.text.toPlainText() == 'Address *'
    );
    expect(addressRichText, findsOneWidget);

    // Find TextFormFields and verify their values
    final textFields = find.byType(TextFormField);
    expect(textFields, findsNWidgets(3));

    final firstNameField = tester.widget<TextFormField>(textFields.at(0));
    expect(firstNameField.controller?.text, equals('John'));

    final lastNameField = tester.widget<TextFormField>(textFields.at(1));
    expect(lastNameField.controller?.text, equals('Doe'));

    final addressField = tester.widget<TextFormField>(textFields.at(2));
    expect(addressField.controller?.text, equals('Test Address'));
  });

  testWidgets('Shows loading indicator when updating profile', (WidgetTester tester) async {
    // Set up initial user and form values
    const user = User(
      firstName: 'John',
      lastName: 'Doe',
      address: 'Test Address',
      phone: '1234567890'
    );
    mockViewModel.setUser(user);

    // Set command to running state
    when(() => updateProfileCommand.running).thenReturn(true);

    await tester.pumpWidget(MaterialApp(
      home: UpdateProfileScreen(viewModel: mockViewModel),
    ));

    await tester.enterText(
      find.widgetWithText(TextFormField, 'John'),
      'Jane'
    );
    await tester.pump();

    // Tap the save button
    await tester.tap(find.text('Save changes'));
    await tester.pump();

    // Verify loading indicator is shown
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    
    // Verify button is in loading state
    final buttonContainer = find.descendant(
      of: find.byType(Container),
      matching: find.byWidgetPredicate((widget) => 
        widget is Container && 
        widget.decoration is BoxDecoration && 
        (widget.decoration as BoxDecoration).color == const Color.fromRGBO(16, 35, 64, 1)
      )
    ).evaluate().first.widget as Container;
    
    expect(buttonContainer, isNotNull);
  });

}