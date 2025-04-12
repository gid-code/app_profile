import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = false,
  });

  final String title;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      leadingWidth: showBackButton ? 72 : 16,
      leading: showBackButton ? Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: CircleAvatar(
          radius: 14,
          backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
          child: IconButton(
            icon: const Icon(
              CupertinoIcons.arrow_left,
              color: Color.fromRGBO(61, 61, 61, 1)
            ),
            onPressed: () => context.pop(),
          ),
        ),
      ) : null,
      title: Text(
        title,
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: const Color.fromRGBO(61, 61, 61, 1),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}