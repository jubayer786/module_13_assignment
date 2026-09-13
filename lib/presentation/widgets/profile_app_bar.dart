import 'dart:convert';
import 'package:flutter/material.dart';
import '../../data/utils/auth_utility.dart';
import '../screens/auth/sign_in_screen.dart';
import '../screens/update_profile_screen.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isUpdateProfile;

  const ProfileAppBar({super.key, this.isUpdateProfile = false});

  @override
  Widget build(BuildContext context) {
    final user = AuthUtility.userInfo;

    return AppBar(
      backgroundColor: const Color(0xFF2196F3),
      elevation: 2,
      title: GestureDetector(
        onTap: () {
          if (!isUpdateProfile) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const UpdateProfileScreen(),
              ),
            );
          }
        },
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              backgroundImage: (user?.photo != null && user!.photo!.isNotEmpty)
                  ? _getUserImage(user.photo!)
                  : null,
              child: (user?.photo == null || user!.photo!.isEmpty)
                  ? const Icon(Icons.person, color: Color(0xFF2196F3))
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    user?.fullName.isNotEmpty == true
                        ? user!.fullName
                        : 'User Name',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    user?.email ?? 'user@email.com',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          onPressed: () => _showLogoutDialog(context),
          icon: const Icon(Icons.logout, color: Colors.white),
          tooltip: 'Logout',
        ),
      ],
    );
  }

  ImageProvider? _getUserImage(String photoBase64) {
    try {
      if (photoBase64.contains('data:image')) {
        photoBase64 = photoBase64.split(',').last;
      }
      return MemoryImage(base64Decode(photoBase64));
    } catch (_) {
      return null;
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              await AuthUtility.clearUserInfo();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInScreen()),
                  (route) => false,
                );
              }
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
