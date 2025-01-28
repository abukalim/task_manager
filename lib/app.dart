import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/sign_in_screen.dart';
import 'package:task_manager/ui/screens/sign_up_screen.dart';
import 'package:task_manager/ui/screens/forgot_password_email_verification.dart';  // Corrected spelling
import 'package:task_manager/ui/screens/forgot_password_otp_verification.dart';    // Corrected spelling
import 'package:task_manager/ui/screens/main_bottom_nav_screen.dart';
import 'package:task_manager/ui/screens/recovery_password_screen.dart';
import 'package:task_manager/ui/screens/splash_screen.dart';
import 'package:task_manager/ui/screens/update_profile_screen.dart';
import 'package:task_manager/ui/screens/add_new_task_screen.dart';
import 'package:task_manager/ui/utils/app_colors.dart';


class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _buildAppTheme(),
      initialRoute: SplashScreen.routeName,
      onGenerateRoute: _getRoute,
    );
  }

  // Define app theme to keep build method cleaner
  ThemeData _buildAppTheme() {
    return ThemeData(
      colorSchemeSeed: AppColors.themColor,
      textTheme: _buildTextTheme(),
      elevatedButtonTheme: _buildElevatedButtonTheme(),
      inputDecorationTheme: _buildInputDecorationTheme(),
    );
  }

  // Define the text theme separately for clarity
  TextTheme _buildTextTheme() {
    return TextTheme(
      headlineMedium: TextStyle(
        fontSize: 28,
        fontFamily: 'poppins',
        fontWeight: FontWeight.w600,
        color: Color(0xff2e374f),
      ),
      bodyMedium: TextStyle(
        fontFamily: 'roboto',
        color: Color(0xff989898),
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        fontFamily: 'poppins',
        fontWeight: FontWeight.w400,
        color: Color(0xff5f5f5f),
      ),
      labelLarge: TextStyle(
        fontSize: 13,
        fontFamily: 'poppins',
        fontWeight: FontWeight.w600,
        color: Color(0xff2e374f),
      ),
    );
  }

  // Elevated button styling
  ElevatedButtonThemeData _buildElevatedButtonTheme() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.themColor,
        foregroundColor: Colors.white,
        fixedSize: Size.fromWidth(double.maxFinite),
        textStyle: TextStyle(fontSize: 16),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  // Input decoration styling
  InputDecorationTheme _buildInputDecorationTheme() {
    return InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      hintStyle: TextStyle(
        fontSize: 11,
        fontFamily: 'roboto',
        fontWeight: FontWeight.w300,
        color: Color(0xffc0c0c0),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(8),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  // Refactored route generation for better clarity and error handling
  Route<dynamic> _getRoute(RouteSettings settings) {
    late Widget widget;

    switch (settings.name) {
      case SplashScreen.routeName:
        widget = const SplashScreen();
        break;
      case SignInScreen.routeName:
        widget = const SignInScreen();
        break;
      case SignUpScreen.routeName:
        widget = const SignUpScreen();
        break;
      case ForgotPasswordEmailVerification.routeName:
        widget = const ForgotPasswordEmailVerification();
        break;
      case ForgotPasswordVerifyOtpScreen.name:
        final String gmail = settings.arguments as String? ?? '';
        widget = ForgotPasswordVerifyOtpScreen(gmail: gmail);
        break;
      case RecoveryPasswordScreen.routeName:
        widget = RecoveryPasswordScreen();
        break;
      case MainBottomNavScreen.name:
        widget = const MainBottomNavScreen();
        break;
      case AddNewTaskScreen.name:
        widget = const AddNewTaskScreen();
        break;
      case UpdateProfileScreen.name:
        widget = const UpdateProfileScreen();
        break;
      default:
        widget = const SignInScreen(); // Default screen
    }

    return MaterialPageRoute(builder: (context) => widget);
  }
}
