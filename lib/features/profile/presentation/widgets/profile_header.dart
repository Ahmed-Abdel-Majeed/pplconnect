import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final Map profileData;
  const ProfileHeader({super.key, required this.profileData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 80,
          backgroundImage: profileData["profImg"] != null
              ? NetworkImage(profileData["profImg"])
              : const AssetImage('assets/default_avatar.png') as ImageProvider,
          backgroundColor: Colors.transparent,
        ),
        const SizedBox(height: 10),
        Text(
          profileData["userName"] ?? 'User',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          profileData["userBio"] ?? 'Bio not available',
          style: TextStyle(fontSize: 18, color: Colors.grey.shade400),
        ),
      ],
    );
  }
}
