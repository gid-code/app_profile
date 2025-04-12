import 'package:go_router/go_router.dart';
import 'package:new_my_app/ui/account/account_viewmodel.dart';
import 'package:new_my_app/ui/account/accounts_screen.dart';
import 'package:new_my_app/main.dart';
import 'package:new_my_app/navigation/routes.dart';
import 'package:new_my_app/ui/account/profile/update_profile_screen.dart';
import 'package:provider/provider.dart';

final GoRouter router = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: Routes.account,
  routes: [
    GoRoute(
      path: Routes.account,
      builder: (context, state){
        final viewModel = AccountViewmodel(
          profileRepository: context.read(),
          userRepository: context.read(),
        );
        viewModel.load.execute();
        return AccountsScreen(viewModel: viewModel);
      },
      routes: [
        GoRoute(
          path: Routes.updateProfile,
          builder: (context, state){
            final viewModel = AccountViewmodel(
              profileRepository: context.read(),
              userRepository: context.read(),
            );
            viewModel.load.execute();
            return UpdateProfileScreen(viewModel: viewModel);
          },
        ),
      ]
    ),
  ]
);