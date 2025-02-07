import 'package:flutter/material.dart';
import 'package:pplconnect/core/navigation/app_navigator.dart';

import '../../../../core/services/firebase_service.dart';
import '../widgets/auth_footer.dart';
import '../widgets/continue_button.dart';
import '../widgets/email_field.dart';
import '../widgets/password_field.dart';
import 'register_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool isLoading = false;

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Container(
          height: double.infinity,
          constraints: const BoxConstraints(maxWidth: 600),
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  color: Colors.black,
                ),
              ),
              
              Positioned(
                bottom: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40),
                      topLeft: Radius.circular(40),
                    ),
                  ),
                  height: screenHeight * 0.7,
                  width: screenWidth > 600 ? 600 : screenWidth,
                ),
              ),
              Positioned(
                top: screenHeight * 0.2,
                left: 20,
                child: Text(
                  "Sign In",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ),
                  Positioned(
                top: screenHeight * 0.1,
                left: 55,
                child: Text(
                  "Welcome Back!",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ),
              Positioned(
                left: 20,
                top: screenHeight * 0.4,
                child: SizedBox(
                  width: screenWidth * 0.9,
                  child: EmailField(
                    emailController: emailController,
                  ),
                ),
              ),
              Positioned(
                left: 20,
                top: screenHeight * 0.48,
                child: SizedBox(
                  width: screenWidth > 600 ? 600 * 0.9 : screenWidth * 0.9,
                  child: PasswordField(
                    passwordController: passwordController,
                  ),
                ),
              ),
              Positioned(
                top: screenHeight * 0.57,
                left: 20,
                child: SizedBox(
                  width: screenWidth * 0.9,
                  child: ContinueButton(
                    isLoading: isLoading,
                    onPressed: () async {
                      if (isLoading) return;

                      setState(() {
                        isLoading = true;
                      });

                      try {
                        await AuthService().signIn(
                          emailAddress: emailController.text,
                          password: passwordController.text,
                          context: context,
                        );
                        setState(() {
                          
                        });
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Error: $e")),
                        );
                      }
                      setState(() {
                        isLoading = false;
                      });
                    },
                  ),
                ),
              ),
              Positioned(
                top: screenHeight * 0.65,
                left: 20,
                child: SizedBox(
                  width: screenWidth * 0.9,
                  child: AuthFooter(
                    onActionPressed: () {
                      AppNavigator.push(context, RegisterPage());
                    },
                  ),
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
            ],
          ),
        ),
      ),
    );
  }
}
