import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';  // Make sure this import is added for AlertDialog and TextButton
import 'package:http/http.dart';
import 'package:task_manager/app.dart';
import 'package:task_manager/ui/screens/sign_in_screen.dart';
import '../../ui/controllers/auth_controller.dart';

class NetworkResponse {
  final int statusCode;
  final Map<String, dynamic>? responseData;
  final bool isSuccess;
  final String errorMessage;

  NetworkResponse({
    required this.isSuccess,
    required this.statusCode,
    this.responseData,
    this.errorMessage = 'Something went wrong!',
  });
}

class NetworkCaller {
  // Handle GET requests
  static Future<NetworkResponse> getRequest({required String url}) async {
    int retryCount = 3;
    while (retryCount > 0) {
      try {
        Uri uri = Uri.parse(url);
        debugPrint('URL => $url');
        Response response = await get(uri, headers: {'token': AuthController.accessToken ?? ''});
        debugPrint('Response Code => ${response.statusCode}');
        debugPrint('Response Data => ${response.body}');

        if (response.statusCode == 200) {
          final decodedResponse = jsonDecode(response.body);
          return NetworkResponse(
            isSuccess: true,
            statusCode: response.statusCode,
            responseData: decodedResponse,
          );
        } else {
          return _handleError(response);
        }
      } catch (e) {
        retryCount--;
        if (retryCount == 0) {
          return NetworkResponse(
            isSuccess: false,
            statusCode: -1,
            errorMessage: 'Failed after multiple attempts: ${e.toString()}',
          );
        }
      }
    }
    return NetworkResponse(isSuccess: false, statusCode: -1, errorMessage: 'Unknown error');
  }

  // Handle POST requests
  static Future<NetworkResponse> postRequest({required String url, Map<String, dynamic>? body}) async {
    try {
      Uri uri = Uri.parse(url);
      debugPrint('URL => $url');
      debugPrint('BODY => $body');
      Response response = await post(uri,
        headers: {
          'content-type': 'application/json',
          'token': AuthController.accessToken ?? ''
        },
        body: jsonEncode(body),
      );
      debugPrint('Response Code => ${response.statusCode}');
      debugPrint('Response Data => ${response.body}');

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: decodedResponse,
        );
      } else {
        return _handleError(response);
      }
    } catch (e) {
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  static Future<NetworkResponse> registerRequest({required String url, Map<String, dynamic>? body}) async {
    try {
      Uri uri = Uri.parse(url);
      debugPrint('URL => $url');
      debugPrint('BODY => $body');
      Response response = await post(uri,
        headers: {
          'content-type': 'application/json',
        },
        body: jsonEncode(body),
      );
      debugPrint('Response Code => ${response.statusCode}');
      debugPrint('Response Data => ${response.body}');

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: decodedResponse,
        );
      } else {
        return _handleError(response);
      }
    } catch (e) {
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }


  // Handle errors based on the status code
  static NetworkResponse _handleError(Response response) {
    if (response.statusCode == 401) {
      _logout();
      return NetworkResponse(
        isSuccess: false,
        statusCode: response.statusCode,
        errorMessage: 'Unauthorized. Please log in again.',
      );
    } else if (response.statusCode == 404) {
      return NetworkResponse(
        isSuccess: false,
        statusCode: response.statusCode,
        errorMessage: 'Resource not found.',
      );
    } else if (response.statusCode == 500) {
      return NetworkResponse(
        isSuccess: false,
        statusCode: response.statusCode,
        errorMessage: 'Server error. Please try again later.',
      );
    } else {
      return NetworkResponse(
        isSuccess: false,
        statusCode: response.statusCode,
        errorMessage: 'Unexpected error occurred.',
      );
    }
  }

  // Log the user out in case of unauthorized access
  static Future<void> _logout() async {
    bool shouldLogout = await showDialog(
      context: TaskManagerApp.navigatorKey.currentContext!,
      builder: (context) => AlertDialog(
        title: Text('Session Expired'),
        content: Text('Your session has expired. Please log in again.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Log Out'),
          ),
        ],
      ),
    ) ?? false;

    if (shouldLogout) {
      await AuthController.clearUserData();
      Navigator.pushNamedAndRemoveUntil(
        TaskManagerApp.navigatorKey.currentContext!,
        SignInScreen.routeName,
            (_) => false,
      );
    }
  }
}
