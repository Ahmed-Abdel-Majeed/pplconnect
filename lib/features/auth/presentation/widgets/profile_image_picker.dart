import 'dart:typed_data';

import 'package:flutter/material.dart';

class ProfileImagePicker extends StatelessWidget {
  final Uint8List? image;
  final VoidCallback onPickImage;

  const ProfileImagePicker({
    super.key,
    required this.image,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPickImage,
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color.fromARGB(255, 251, 232, 232),
        ),
        child: Stack(
          children: [
            _buildImageContent(),
            Positioned(
              bottom: -6,
              right: -12,
              child: IconButton(
                icon: const Icon(Icons.add_a_photo),
                onPressed: onPickImage,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageContent() {
    return CircleAvatar(
      radius: 60,
      backgroundColor: Colors.transparent,
      child: ClipOval(
        child: image != null
            ? Image.memory(
                image!,
                width: 145,
                height: 145,
                fit: BoxFit.cover,
              )
            : Image.asset(
                'assets/images/av.jpg',
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}