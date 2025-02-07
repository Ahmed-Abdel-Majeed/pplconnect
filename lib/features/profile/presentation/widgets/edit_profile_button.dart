import 'package:flutter/material.dart';

class EditProfileButton extends StatelessWidget {
  final bool isCurrentUser;
  final bool isFollowing;
  final VoidCallback onEdit;

  const EditProfileButton({
    super.key,
    required this.isCurrentUser,
    required this.isFollowing,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: onEdit,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isFollowing ? Colors.redAccent : Colors.purpleAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: Text(
                isCurrentUser
                    ? 'Edit Profile'
                    : isFollowing
                        ? 'UnFollow'
                        : 'Follow',
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}
