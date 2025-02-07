import 'package:flutter/material.dart';

import '../pages/follower_following_page.dart';

class ProfileStats extends StatelessWidget {
  final int postCount;
  final int followers;
  final int following;
  final String userId;

  const ProfileStats({
    super.key,
    required this.postCount,
    required this.followers,
    required this.following,
    required this.userId,
  });

  Widget _buildStatItem(String count, String label) {
    return Column(
      children: <Widget>[
        Text(
          count,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade400),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildStatItem(postCount.toString(), 'Posts'),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FollowersFollowingScreen(
                    userId: userId,
                    isFollowing: false,
                  ),
                ),
              );
            },
            child: _buildStatItem(followers.toString(), 'Followers'),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FollowersFollowingScreen(
                    userId: userId,
                    isFollowing: true,
                  ),
                ),
              );
            },
            child: _buildStatItem(following.toString(), 'Following'),
          ),
        ],
      ),
    );
  }
}
