import 'dart:math';
import 'dart:typed_data' show Uint8List;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pplconnect/features/auth/presentation/pages/sign_in_page.dart';
import 'package:path/path.dart' show basename;
import '../../../../core/navigation/app_navigator.dart';
import '../../../../core/services/firebase_service.dart';
import '../../../../core/utils/snackbar.dart';
import '../../../home/presentation/main_screen.dart';
import '../widgets/auth_footer.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/continue_button.dart';
import '../widgets/password_field.dart';
import '../widgets/password_strength_indicator.dart';
import '../widgets/profile_image_picker.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  final phoneController = TextEditingController();

  bool isLoading = false;
  bool isPasswordValid1 = false;
  bool isPasswordValid2 = false;
  bool isPasswordValid3 = false;
  bool isPasswordValid4 = false;
  Uint8List? imgPath;
  String? imgName;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

// add reg
  Future<void> _handleRegistration() async {
    if (!_formKey.currentState!.validate()) return;
    if (imgPath == null) {
      showSnackBar(context, "Please select a profile image");
      return;
    }

    setState(() => isLoading = true);

    try {
      await AuthService().register(
        emailAddress: emailController.text,
        password: passwordController.text,
        context: context,
        userName: usernameController.text,
        phoneNumber: phoneController.text,
        imgPath: imgPath,
        imgName: imgName,
      );
      AppNavigator.pushReplacement(context, const MainScreen());
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _passwordChanged(String password) {
    setState(() {
      isPasswordValid1 = password.length >= 8;
      isPasswordValid2 = password.contains(RegExp(r'[0-9]'));
      isPasswordValid3 = password.contains(RegExp(r'[A-Z]'));
      isPasswordValid4 = password.contains(RegExp(r'[a-z]'));
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedImg = await ImagePicker().pickImage(source: source);
      if (pickedImg == null) return;

      final bytes = await pickedImg.readAsBytes();
      setState(() {
        imgPath = bytes;
        imgName = "${Random().nextInt(108800)}${basename(pickedImg.path)}";
      });
    } catch (e) {
      showSnackBar(context, "Error picking image: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Colors.black,
            ),
          ),
          Positioned(
              top: screenHeight * .09,
              left: 11,
              child: Text(
                "Creat An Account",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              )),

          Positioned(
            top: screenHeight * .25,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(40),
                  topLeft: Radius.circular(40),
                ),
              ),
              height: screenHeight,
              width: screenWidth,
            ),
          ),
          Positioned(
            // top: screenHeight*.05,
            bottom: 0,
            right: screenWidth * .24,

            child: SizedBox(
              height: 100,
              width: 200,
              child: Image.asset(
                "assets/images/applogo.png",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16, left: 16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * .1),
                  ProfileImagePicker(
                    image: imgPath,
                    onPickImage: _showImageSourceOptions,
                  ),
                  const SizedBox(height: 30),
                  AuthTextField(
                    controller: usernameController,
                    label: "User Name",
                    validator: _validateUsername,
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 20),
                  AuthTextField(
                    controller: emailController,
                    label: "Email Address",
                    keyboardType: TextInputType.emailAddress,
                    validator: _validateEmail,
                    icon: Icons.email,
                  ),
                  const SizedBox(height: 20),
                  AuthTextField(
                    controller: phoneController,
                    label: "Phone Number",
                    keyboardType: TextInputType.phone,
                    validator: _validatePhone,
                    icon: Icons.phone,
                  ),
                  const SizedBox(height: 20),
                  PasswordField(
                    passwordController: passwordController,
                    onChanged: _passwordChanged,
                  ),
                  const SizedBox(height: 20),
                  _buildPasswordRequirements(),
                  const SizedBox(height: 30),
                  ContinueButton(
                    isLoading: isLoading,
                    onPressed: () {
                      _handleRegistration();
                    },
                    buttonText: "Register",
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        "have an account?",
                        style: TextStyle(
                          fontSize: 17,
                          color: Color.fromARGB(255, 152, 152, 152),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          AppNavigator.pushReplacement(context, SignInPage());
                        },
                        child: Text(
                          "  LogIn",
                          style: TextStyle(
                            fontSize: 17,
                            color: Color(0xFF4A90E2),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 70,
                  )
                ],
              ),
            ),
          ),
          // Positioned(
          // top: screenHeight*.166,
          // right: 36,

          // child:  Container(
          //   height: 26,
          //   width: 125,
          //   color: Colors.white,
          // )),
        ],
      ),
    );
  }

  String? _validateUsername(String? value) =>
      value?.isEmpty ?? true ? 'Please enter your name' : null;

  String? _validateEmail(String? email) => email?.contains(RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")) ??
          false
      ? null
      : "Enter a valid email";

  String? _validatePhone(String? value) =>
      value?.length == 11 && RegExp(r'^[0-9]+$').hasMatch(value ?? "")
          ? null
          : "Enter a valid 11-digit phone number";

  Widget _buildPasswordRequirements() {
    return Row(
      children: [
        PasswordStrengthIndicator(
          condition: isPasswordValid1,
          label: "8+ characters",
        ),
        PasswordStrengthIndicator(
          condition: isPasswordValid2,
          label: "Contains number",
        ),
        PasswordStrengthIndicator(
          condition: isPasswordValid3,
          label: "Uppercase letter",
        ),
        PasswordStrengthIndicator(
          condition: isPasswordValid4,
          label: "Lowercase letter",
        ),
      ],
    );
  }

  void _showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }
}
