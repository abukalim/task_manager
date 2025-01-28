import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/screens/sign_in_screen.dart';
import 'package:task_manager/ui/utils/app_colors.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';
import 'package:task_manager/ui/widgets/task_widgets.dart';

import '../controllers/auth_controller.dart';

class RecoveryPasswordScreen extends StatefulWidget {
  static const String routeName = '/Forgot-Password/Recovery-password';
  String? email;
  String? otp;

  RecoveryPasswordScreen({Key? key}) : super(key: key);

  @override
  State<RecoveryPasswordScreen> createState() => _RecoveryPasswordScreenState();
}

class _RecoveryPasswordScreenState extends State<RecoveryPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  Future<void> getEmail() async {
    await Future.delayed(const Duration(seconds: 2));
    String? l = await AuthController.getField('email');
    String? p = await AuthController.getField('otp');
    widget.email = l;
    widget.otp = p;
  }

  @override
  void initState() {
    super.initState();
    getEmail();
  }
  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BackgroundScreen(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(48.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 96.0),
                  Text(
                    'Set Password',
                    style: textTheme.headlineMedium,
                  ),
                  Text(
                    'Minimum length password 6 characters with letter and number combination',
                    style: textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24.0),
                  TextFormField(
                    controller: _passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: const InputDecoration(hintText: 'Password'),
                    validator: (value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your password';
                      }
                      if (value!.length < 6) {
                        return 'Enter a password with more than 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12.0),
                  TextFormField(
                    controller: _confirmPasswordController,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: const InputDecoration(hintText: 'Confirm Password'),
                    validator: (value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your confirm password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24.0),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _recoverPassword,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: AppColors.themColor)
                        : const Text('Confirm'),
                  ),
                  const SizedBox(height: 48.0),
                  Center(child: _buildSignUpSection()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpSection() {
    final textTheme = Theme.of(context).textTheme;

    return RichText(
      text: TextSpan(
        text: "Have an account? ",
        style: textTheme.labelLarge,
        children: [
          TextSpan(
            text: "Sign In",
            style: TextStyle(
              color: AppColors.themColor,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => Navigator.pushNamed(context, SignInScreen.routeName),
          ),
        ],
      ),
    );
  }

  Future<void> _recoverPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final responseBody = {
          "email": widget.email,
          "OTP": widget.otp,
          "password": _passwordController.text, // Use _passwordController.text
        };

        final response = await NetworkCaller.postRequest(
          url: Urls.resetPasswordUrl,
          body: responseBody,
        );

        if (response.isSuccess) {
          showSnackBarMessage(context, "Password recovery success", true);
          Navigator.pushNamedAndRemoveUntil(
            context,
            SignInScreen.routeName,
                (route) => false,
          );
        } else {
          showSnackBarMessage(context, response.errorMessage, false);
        }
      } catch (e) {
        // Handle network or server errors
        setState(() {
          _isLoading = false;
        });
        showSnackBarMessage(context, 'An error occurred. Please try again later.', false);
      } finally {
        // Clear password fields after the operation (success or failure)
        _passwordController.clear();
        _confirmPasswordController.clear();
      }
    }
  }
}