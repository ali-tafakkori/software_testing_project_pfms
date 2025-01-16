import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:software_testing_project_pfms/db/app_database.dart';
import 'package:software_testing_project_pfms/main.dart';
import 'package:software_testing_project_pfms/models/user.dart';
import 'package:software_testing_project_pfms/router.dart';
import 'package:software_testing_project_pfms/widgets/app_button.dart';
import 'package:software_testing_project_pfms/widgets/app_progress_button.dart';
import 'package:software_testing_project_pfms/widgets/app_text_field.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _atfcUser = AppTextFieldController();
  final _atfcPass = AppTextFieldController();

  bool obscurePass = true;
  bool hasFocus = false;
  String? warning;

  AppProgressButtonState state = AppProgressButtonState.idle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsetsDirectional.only(
              start: 24,
              top: 80,
              end: 24,
              bottom: 40,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  CupertinoIcons.person_crop_circle,
                  color: Colors.amber,
                  size: 90,
                ),
                const SizedBox(
                  height: 60,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black.withAlpha(5),
                    border: Border.all(
                      color: hasFocus
                          ? warning != null
                              ? Colors.redAccent
                              : Colors.amber
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      AppTextField(
                        key: const Key("username"),
                        controller: _atfcUser,
                        inputType: TextInputType.text,
                        hintText: "Username",
                        noBorder: true,
                        width: double.infinity,
                        onChanged: (value) {
                          setState(() {
                            warning = null;
                          });
                        },
                        onTap: () {
                          setState(() {
                            hasFocus = true;
                          });
                        },
                      ),
                      Container(
                        height: 1,
                        color: Colors.black26,
                      ),
                      AppTextField(
                        key: const Key("password"),
                        obscure: obscurePass,
                        controller: _atfcPass,
                        inputType: TextInputType.text,
                        noBorder: true,
                        hintText: "Password",
                        width: double.infinity,
                        suffixIcon: _atfcPass.text.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  setState(() {
                                    obscurePass = !obscurePass;
                                  });
                                },
                                icon: Icon(
                                  obscurePass
                                      ? CupertinoIcons.eye
                                      : CupertinoIcons.eye_slash,
                                  color: Colors.amber,
                                ),
                              )
                            : null,
                        onChanged: (value) {
                          setState(() {
                            warning = null;
                          });
                        },
                        onTap: () {
                          setState(() {
                            hasFocus = true;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                if (warning != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    child: Text(
                      warning.toString(),
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                const SizedBox(
                  height: 40,
                ),
                AppProgressButton(
                  key: const Key("login"),
                  text: "Login",
                  onPressed: onLoginPressed,
                  state: state,
                  color: _atfcUser.text.isNotEmpty
                      ? Colors.amber
                      : Colors.blueGrey,
                ),
                const SizedBox(
                  height: 14,
                ),
                AppButton(
                  key: const Key("register"),
                  text: "Register",
                  onPressed: onRegisterPressed,
                  color: Colors.transparent,
                  textColor: Colors.amber,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onLoginPressed() async {
    var username = _atfcUser.text.trim();
    var password = _atfcPass.text.trim();
    FocusScope.of(context).children.forEach((FocusNode f) {
      f.unfocus();
    });
    if (username.isEmpty && password.isEmpty) {
      hasFocus = true;
      warning = "Username and Password are required.";
    } else if (username.length < 3) {
      hasFocus = true;
      warning = "Username is required.";
      _atfcUser.requestFocus(context);
    } else if (password.length < 5) {
      hasFocus = true;
      warning = "Password is required.";
      _atfcPass.requestFocus(context);
    } else {
      setState(() {
        state = AppProgressButtonState.loading;
        warning = null;
      });
      User? user = await AppDatabase.instance.userDao
          .findByUsernameAndPassword(username, password);
      if (user != null) {
        if (mounted) {
          MyApp.of(context)?.userId = user.id;
          ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
          Navigator.of(context).pushNamed(Routes.home.toString());
        }
      } else {
        hasFocus = true;
        warning = "The information entered is incorrect.";
      }
      state = AppProgressButtonState.idle;
    }
    setState(() {});
  }

  void onRegisterPressed() {
    Navigator.of(context).pushNamed<bool?>(Routes.register.toString()).then(
      (value) {
        if (value == true) {
          if (mounted) {
            ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
              content: const Text("Now you can log in."),
              leading: const Icon(CupertinoIcons.info),
              actions: [
                TextButton(
                  child: const Text('Dismiss'),
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                  },
                ),
              ],
            ));
          }
        }
      },
    );
  }
}
