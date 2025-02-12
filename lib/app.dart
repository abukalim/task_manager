import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/screens/forgot_password_verify_email_screen.dart';
import 'package:task_manager/ui/screens/forgot_password_verify_otp_screen.dart';
import 'package:task_manager/ui/screens/reset_password_screen.dart';
import 'package:task_manager/ui/screens/sign_in_screen.dart';
import 'package:task_manager/ui/screens/sign_up_screen.dart';   // Corrected spelling
import 'package:task_manager/ui/screens/main_bottom_nav_screen.dart';
import 'package:task_manager/ui/screens/splash_screen.dart';
import 'package:task_manager/ui/screens/update_profile_screen.dart';
import 'package:task_manager/ui/screens/add_new_task_screen.dart';
import 'package:task_manager/ui/utils/app_colors.dart';


class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _buildAppTheme(),
      initialRoute: SplashScreen.name,
      getPages: _getPages(),
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
  List<GetPage> _getPages() {
    return [
      GetPage(
        name: SplashScreen.name,
        page: () => const SplashScreen(),
        transition: Transition.fadeIn,
      ),
      GetPage(
        name: SignInScreen.name,
        page: () => SignInScreen(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: SignUpScreen.name,
        page: () => SignUpScreen(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: ForgotPasswordVerifyEmailScreen.name,
        page: () => const ForgotPasswordVerifyEmailScreen(),
        transition: Transition.downToUp,
      ),
      GetPage(
        name: ForgotPasswordVerifyOtpScreen.name,
        page: () {
          final String gmail = Get.arguments as String? ?? '';
          return ForgotPasswordVerifyOtpScreen(email: gmail);
        },
        transition: Transition.zoom,
      ),
      GetPage(
        name: ResetPasswordScreen.name,
        page: () => ResetPasswordScreen(),
        transition: Transition.fadeIn,
      ),
      GetPage(
        name: MainBottomNavScreen.name,
        page: () => const MainBottomNavScreen(),
        transition: Transition.fadeIn,
      ),
      GetPage(
        name: AddNewTaskScreen.name,
        page: () => const AddNewTaskScreen(),
        transition: Transition.rightToLeftWithFade,
      ),
      GetPage(
        name: UpdateProfileScreen.name,
        page: () => const UpdateProfileScreen(),
        transition: Transition.leftToRightWithFade,
      ),
    ];
  }
}
