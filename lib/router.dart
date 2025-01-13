import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:software_testing_project_pfms/home/home.dart';
import 'package:software_testing_project_pfms/home/purchase_details.dart';
import 'package:software_testing_project_pfms/login/login.dart';
import 'package:software_testing_project_pfms/login/register.dart';

enum Routes {
  login,
  register,
  home,
  purchaseDetails,
}

Route<dynamic> generateRoute(RouteSettings settings) {
  if (settings.name == Routes.login.toString() ||
      settings.name == Navigator.defaultRouteName) {
    return MaterialPageRoute(
      builder: (context) {
        return const Login();
      },
    );
  } else if (settings.name == Routes.register.toString()) {
    return CupertinoPageRoute<bool?>(
      builder: (context) {
        return const Register();
      },
    );
  } else if (settings.name == Routes.home.toString()) {
    return CupertinoPageRoute(
      builder: (context) {
        return const Home();
      },
    );
  } else if (settings.name == Routes.purchaseDetails.toString()) {
    Map<String, dynamic>? map = settings.arguments as Map<String, dynamic>?;
    return CupertinoPageRoute(
      builder: (context) {
        return PurchaseDetails(
          customerId: map?["customerId"],
          dateTime: map?["dateTime"],
        );
      },
    );
  }

  return MaterialPageRoute(
    builder: (context) => const Scaffold(),
  );
}
