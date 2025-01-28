import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/utils/app_colors.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

import '../../data/models/user_model.dart';
import '../controllers/auth_controller.dart';
import '../widgets/task_widgets.dart';
import 'main_bottom_nav_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static const String routeName = '/signUpScreen';  // Changed 'name' to 'routeName'

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _gmailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool signUpInProgress = false;

  @override
  Widget build(BuildContext context) {
    final textThem = Theme.of(context).textTheme;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BackgroundScreen(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 88),
                  Text(
                    'Join With Us',
                    style: textThem.headlineMedium,
                  ),
                  SizedBox(height: 24),
                  _buildTextField(_gmailTEController, 'Gmail', TextInputType.emailAddress),
                  SizedBox(height: 8),
                  _buildTextField(_firstNameTEController, 'First Name'),
                  SizedBox(height: 8),
                  _buildTextField(_lastNameTEController, 'Last Name'),
                  SizedBox(height: 8),
                  _buildTextField(_mobileTEController, 'Mobile', TextInputType.number),
                  SizedBox(height: 8),
                  _buildTextField(_passwordTEController, 'Password', TextInputType.visiblePassword, true),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: signUpInProgress ? null : _onTabSignUpButton,
                    child: signUpInProgress
                        ? CircularProgressIndicator(color: AppColors.themColor)
                        : Icon(Icons.arrow_circle_right_outlined, color: Colors.white, size: 24),
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

  Widget _buildTextField(TextEditingController controller, String hintText, [TextInputType? inputType, bool obscureText = false]) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      obscureText: obscureText,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.black), // Dark black color for placeholder text
      ),
      validator: (value) {
        if (value?.trim().isEmpty ?? true) {
          return 'Enter your $hintText';
        }
        if (hintText == 'Password' && value!.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }

  Widget buildSignUpSection() {
    final textThem = Theme.of(context).textTheme;
    return RichText(
      text: TextSpan(
        text: "Have account? ",
        style: textThem.labelLarge,
        children: [
          TextSpan(
            text: "Sign in",
            style: TextStyle(
              color: AppColors.themColor,
              fontFamily: 'poppins',
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

  void _onTabSignUpButton() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        signUpInProgress = true;
      });
      _register();
    }
  }

  Future<void> _register() async {
    Map<String, dynamic> requestBody = {
      "email": _gmailTEController.text.trim(),
      "firstName": _firstNameTEController.text.trim(),
      "lastName": _lastNameTEController.text.trim(),
      "mobile": _mobileTEController.text.trim(),
      "password": _passwordTEController.text,
      "photo": "",
    };

    final NetworkResponse response = await NetworkCaller.registerRequest(
      url: Urls.registrationUrl,
      body: requestBody,
    );

    setState(() {
      signUpInProgress = false;
    });

    if (response.isSuccess) {
      String status = response.responseData!['status'];
      if (status == 'fail') {
        showSnackBarMessage(
          context, 'Already created an account using this email.', false,
        );
        _gmailTEController.clear();
      } else {
        showSnackBarMessage(context, 'Registration successful!', true);
        Future.delayed(
          Duration(milliseconds: 500),
              () => _signIn(),
        );
      }
    } else {
      showSnackBarMessage(context, response.errorMessage, false);
    }
  }

  Future<void> _signIn() async {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: SizedBox(
            height: 50,
            width: 50,
            child: CircularProgressIndicator(),
          ),
        );
      },
    );

    Map<String, dynamic> requestBody = {
      "email": _gmailTEController.text.trim(),
      "password": _passwordTEController.text,
    };

    NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.loginUrl,
      body: requestBody,
    );

    _clearTextFields();

    if (response.isSuccess) {
      String token = response.responseData!['token'];
      UserModel userModel = UserModel.fromJson(response.responseData!['data']);
      await AuthController.saveUserData(token, userModel);
      Navigator.pushNamedAndRemoveUntil(
        context,
        MainBottomNavScreen.name,
            (route) => false,
      );
    } else {
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  void _clearTextFields() {
    _gmailTEController.clear();
    _firstNameTEController.clear();
    _lastNameTEController.clear();
    _mobileTEController.clear();
    _passwordTEController.clear();
  }

  @override
  void dispose() {
    _gmailTEController.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _mobileTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}
