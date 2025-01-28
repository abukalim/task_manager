import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/sign_in_screen.dart';

import '../controllers/auth_controller.dart';
import '../screens/update_profile_screen.dart';
import '../utils/app_colors.dart';

class TMAppBar extends StatelessWidget implements PreferredSizeWidget {
  TMAppBar({
    super.key,
    this.fromUpdateProfile = false,
  });

  final bool fromUpdateProfile;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.themColor,
      title: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundImage: (AuthController.userModel?.photo?.isNotEmpty ?? false)
                ? MemoryImage(base64Decode(AuthController.userModel?.photo ?? ''))
                : const AssetImage('assets/images/default_avatar.png') as ImageProvider, // Default avatar fallback
            onBackgroundImageError: (_, __) => const Icon(Icons.person_outline),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () {
              if (!fromUpdateProfile) {
                Navigator.pushNamed(context, UpdateProfileScreen.name);
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AuthController.userModel?.fullName ?? 'Full Name not available',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontFamily: 'poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  AuthController.userModel?.email ?? 'Email not available',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontFamily: 'poppins',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        PopupMenuButton(
          icon: const Icon(Icons.more_vert),
          itemBuilder: (BuildContext context) => [
            PopupMenuItem(
              child: Row(
                children: const [
                  Icon(
                    Icons.logout,
                    size: 20,
                  ),
                  SizedBox(width: 6),
                  Text('Log Out'),
                ],
              ),
              onTap: () async {
                await AuthController.clearUserData();
                Navigator.pushNamedAndRemoveUntil(
                    context, SignInScreen.routeName, (Route<dynamic> route) => false);
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
