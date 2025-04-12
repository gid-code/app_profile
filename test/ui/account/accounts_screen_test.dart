import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_my_app/data/services/api/models/update_profile_request/update_profile_request.dart';
import 'package:new_my_app/models/user/user.dart';
import 'package:new_my_app/ui/account/account_viewmodel.dart';
import 'package:new_my_app/ui/account/accounts_screen.dart';
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

class MockCommand0 extends Mock implements Command0 {
  @override
  bool get running => false;

  @override
  bool get error => false;

  @override
  bool get completed => true;

  @override
  Future<Result> execute() async => const Result.ok(null);
}

class MockCommand1<T, A> extends Mock implements Command1<T, A> {
  @override
  bool get running => false;

  @override
  bool get error => false;

  @override
  bool get completed => true;

  @override
  Future<Result> execute(A arg) async => const Result.ok(null);
}

void main() {
  late MockAccountViewModel mockViewModel;
  late MockCommand0 loadCommand;
  late MockCommand1<void, UpdateProfileRequest> updateProfileCommand;

  setUp(() {
    mockViewModel = MockAccountViewModel();
    loadCommand = MockCommand0();
    updateProfileCommand = MockCommand1<void, UpdateProfileRequest>();
    
    mockViewModel.load = loadCommand;
    mockViewModel.updateProfile = updateProfileCommand;
  });

  testWidgets('AccountsScreen displays user information', (WidgetTester tester) async {
    const user = User(
      firstName: 'John',
      lastName: 'Doe',
      phone: '1234567890',
      address: 'Test Address'
    );
    
    mockViewModel.setUser(user);

    await tester.pumpWidget(MaterialApp(
      home: AccountsScreen(viewModel: mockViewModel),
    ));

    // Check if user's name is displayed
    expect(find.text('John Doe'), findsOneWidget);
    // Check if phone number is displayed
    expect(find.text('1234567890'), findsOneWidget);
    // Check if initials are displayed
    expect(find.text('JD'), findsOneWidget);
  });

  testWidgets('AccountsScreen shows all action items', (WidgetTester tester) async {
    mockViewModel.setUser(const User(
      firstName: 'John',
      lastName: 'Doe',
      phone: '1234567890',
      address: 'Test Address'
    ));

    await tester.pumpWidget(MaterialApp(
      home: AccountsScreen(viewModel: mockViewModel),
    ));

    // Check if all action items are present
    expect(find.text('Update profile'), findsOneWidget);
    expect(find.text('Service preference'), findsOneWidget);
    expect(find.text('Availability'), findsOneWidget);
    expect(find.text('Manage notifications'), findsOneWidget);
    expect(find.text('Support'), findsOneWidget);
    expect(find.text('Change password'), findsOneWidget);
    expect(find.text('Request account deletion'), findsOneWidget);
    expect(find.text('Logout'), findsOneWidget);
    expect(find.text('App version'), findsOneWidget);
  });

  testWidgets('Bottom navigation bar shows correct items', (WidgetTester tester) async {
    mockViewModel.setUser(const User(
      firstName: 'John',
      lastName: 'Doe',
      phone: '1234567890',
      address: 'Test Address'
    ));

    await tester.pumpWidget(MaterialApp(
      home: AccountsScreen(viewModel: mockViewModel),
    ));

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Requests'), findsOneWidget);
    expect(find.text('Account'), findsAtLeast(2));
  });
}