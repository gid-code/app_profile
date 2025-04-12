import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:new_my_app/core/ui/custom_app_bar.dart';
import 'package:new_my_app/navigation/routes.dart';
import 'package:new_my_app/ui/account/account_viewmodel.dart';

class AccountsScreen extends StatefulWidget {
  const AccountsScreen({super.key, required this.viewModel});

  final AccountViewmodel viewModel;

  @override
  State<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  final int _selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Account"),
      backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
      body: SafeArea(
        top: true,
        bottom: true,
        child: ListenableBuilder(
          listenable: widget.viewModel,
          builder: (context, _) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(224, 224, 224, 1),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          widget.viewModel.user?.initials ?? "",
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: const Color.fromRGBO(122, 122, 122, 1),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.viewModel.user?.fullName ?? "",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: const Color.fromRGBO(61, 61, 61, 1)
                      )
                    ),
                    Text(
                      widget.viewModel.user?.phone ?? "",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: const Color.fromRGBO(122, 122, 122, 1)
                      ),
                    ),
                    const SizedBox(height: 20),
                    Card(
                      color: const Color.fromRGBO(255, 255, 252, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      child: Column(
                        children: [
                          actionItem(context, "user","Update profile",Routes.updateProfile),
                          itemDivider(),
                          actionItem(context, "monitor-mobbile2","Service preference",null),
                          itemDivider(),
                          actionItem(context, "clock","Availability",null),
                          itemDivider(),
                          actionItem(context, "notification-status","Manage notifications",null),
                          itemDivider(),
                          actionItem(context, "messages-2","Support",null),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Card(
                      color: const Color.fromRGBO(255, 255, 252, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      child: Column(
                        children: [
                          actionItem(context, "lock","Change password",null),
                          itemDivider(),
                          actionItem(context, "danger","Request account deletion",null),
                          itemDivider(),
                          appAction(context, Colors.red, "logout", "Logout", ""),
                          itemDivider(),
                          appAction(context, const Color.fromRGBO(122, 122, 122, 1), "app", "App version", "1.0.0"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        )
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: const Color.fromRGBO(255, 255, 252, 1),
        selectedItemColor: const Color.fromRGBO(45, 99, 180, 1),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: [
          navigationItem("home","Home"),
          navigationItem("monitor-mobbile","Requests"),
          navigationItem("user-bold","Account"),
        ],
        onTap: (index) {
          // setState(() {
          //   _selectedIndex = index;
          // });
          // switch (index) {
          //   case 0:
          //     context.go('/home');
          //     break;
          //   case 1:
          //     context.go('/requests');
          //     break;
          //   case 2:
          //     context.go('/');
          //     break;
          // }
        },
      ),
    );
  }

  Divider itemDivider() {
    return const Divider(
      height: 2,
      color: Color.fromRGBO(245, 245, 245, 1),
    );
  }

  BottomNavigationBarItem navigationItem(String svgIcon, String label) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        'assets/icons/$svgIcon.svg',
      ),
      label: label,
    );
  }

  InkWell actionItem(
    BuildContext context, 
    String iconData, 
    String title, 
    String? route) {
    return InkWell(
      onTap: () {
        if (route == null) return;
        context.push('${Routes.account}/$route');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            SvgPicture.asset(
              'assets/icons/$iconData.svg',
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 10),
            Text(title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: const Color.fromRGBO(92, 92, 92, 1),
              ),
            ),
            const Spacer(),
            
            const Icon(
              CupertinoIcons.right_chevron,
              size: 24,
              color: Color.fromRGBO(92, 92, 92, 1),
            ),
          ],
        ),
      ),
    );
  }

  Padding appAction(BuildContext context, Color color, String iconData, String title, String route) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          SvgPicture.asset(
            'assets/icons/$iconData.svg',
            color: color,
            width: 24,
            height: 24,
          ),
          const SizedBox(width: 10),
          Text(title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
          const Spacer(),
          Text(route,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}