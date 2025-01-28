import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/utils/app_colors.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';
import '../controllers/auth_controller.dart';
import '../widgets/task_widgets.dart';
import 'forgot_password_otp_verification.dart';

class ForgotPasswordEmailVerification extends StatefulWidget {
  const ForgotPasswordEmailVerification({super.key});

  static const String routeName = '/forgot_password/email_verification';

  @override
  State<ForgotPasswordEmailVerification> createState() =>
      _ForgotPasswordEmailVerificationState();
}

class _ForgotPasswordEmailVerificationState
    extends State<ForgotPasswordEmailVerification> {
  final TextEditingController _gmailTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _inProgress = false; // Initialize to false for the button to be clickable initially

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BackgroundScreen(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(48),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 96),
                  Text(
                    'Your Email Address',
                    style: textTheme.headlineMedium,
                  ),
                  Text(
                    'A 6 digit verification pin will be sent to your email address',
                    style: textTheme.bodyMedium,
                  ),
                  SizedBox(height: 24),
                  TextFormField(
                    controller: _gmailTEController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Gmail',
                      hintStyle: TextStyle(color: Colors.black), // Dark black color for placeholder text
                    ),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _inProgress ? null : _verifyGmailButton,
                    // Disable when in progress
                    child: _inProgress
                        ? CircularProgressIndicator(
                      color: AppColors.themColor,
                    )
                        : Icon(
                      Icons.arrow_circle_right_outlined,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  SizedBox(height: 48),
                  Center(
                    child: buildSignUpSection(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Refactor buildSignUpSection out of the build method
  Widget buildSignUpSection() {
    final textTheme = Theme.of(context).textTheme;

    return RichText(
      text: TextSpan(
        text: "Have an account? ",
        style: textTheme.labelLarge,
        children: [
          TextSpan(
            text: "Sign up",
            style: TextStyle(
              color: AppColors.themColor,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.pop(context);
              },
          ),
        ],
      ),
    );
  }

  void _verifyGmailButton() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _inProgress = true; // Set in progress to true when the request is made
      });
      _verifyGmail();
    }
  }

  Future<void> _verifyGmail() async {
    NetworkResponse response = await NetworkCaller.getRequest(
        url: '${Urls.recoverVerifyEmailUrl}/${_gmailTEController.text.trim()}');
    setState(() {
      _inProgress = false; // Reset inProgress after network request
    });

    if (response.isSuccess) {
      if (response.responseData!['status'] == 'fail') {
        showSnackBarMessage(context, "No User Found", false);
      } else {
        AuthController.saveField('email', _gmailTEController.text.trim());
        Navigator.pushReplacementNamed(
          context,
          ForgotPasswordVerifyOtpScreen.name,
          arguments: _gmailTEController.text.trim(),
        );
      }
    } else {
      showSnackBarMessage(context, response.errorMessage, false);
    }
  }

  @override
  void dispose() {
    _gmailTEController.dispose();
    super.dispose();
  }
}
