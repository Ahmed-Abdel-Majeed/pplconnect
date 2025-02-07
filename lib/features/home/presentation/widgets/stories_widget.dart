import 'package:flutter/material.dart';

class StoriesWidget extends StatelessWidget {
  const StoriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: const AssetImage('assets/img/444.jpg'),
                  backgroundColor: Colors.purpleAccent.withValues(),
                ),
                const SizedBox(height: 4),
                Text('User $index',
                    style: const TextStyle(fontSize: 12, color: Colors.white)),
              ],
            ),
          );
        },
      ),
    );
  }
}