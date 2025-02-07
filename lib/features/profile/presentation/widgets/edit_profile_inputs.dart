import 'package:flutter/material.dart';

class EditProfileInputs extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController bioController;
  final TextEditingController passwordController;

  const EditProfileInputs({
    super.key,
    required this.nameController,
    required this.bioController,
    required this.passwordController,
  });

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white70),
        filled: true,
        fillColor: Colors.white10,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTextField(
          controller: nameController,
          label: 'Name',
          icon: Icons.person,
        ),
        const SizedBox(height: 20),
        _buildTextField(
          controller: bioController,
          label: 'Bio',
          icon: Icons.info_outline,
          maxLines: 3,
        ),
        const SizedBox(height: 20),
        _buildTextField(
          controller: passwordController,
          label: 'Password',
          icon: Icons.lock_outline,
          obscureText: true,
        ),
      ],
    );
  }
}
