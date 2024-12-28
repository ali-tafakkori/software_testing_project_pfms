import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:software_testing_project_pfms/db/app_database.dart';
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
                CupertinoIcons.person_fill,
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
                    color: hasFocus ? Colors.amber : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    AppTextField(
                      controller: _atfcUser,
                      inputType: TextInputType.text,
                      hintText: "Username",
                      noBorder: true,
                      width: double.infinity,
                      onChanged: (value) {
                        setState(() {});
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
                      controller: _atfcPass,
                      inputType: TextInputType.text,
                      noBorder: true,
                      hintText: "Password",
                      width: double.infinity,
                      onChanged: (value) {
                        setState(() {});
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
                    horizontal: 20,
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
                text: "Login",
                onPressed: onLoginPressed(),
                state: state,
              ),
              const SizedBox(
                height: 14,
              ),
              AppButton(
                text: "Register",
                onPressed: onRegisterPressed,
                color: Colors.transparent,
                textColor: Colors.amber,
              ),
            ],
          ),
        )),
      ),
    );
  }

  VoidCallback? onLoginPressed() {
    var user = _atfcUser.text.trim();
    var pass = _atfcPass.text.trim();
    if (user.isNotEmpty) {
      return () async {
        setState(() {
          state = AppProgressButtonState.loading;
        });
        User? userAccent = await AppDatabase.instance.userDao.findByUserAndPass(user, pass);
        setState(() {
          state = AppProgressButtonState.idle;
        });
      };
    }
    return null;
  }

  void onRegisterPressed() {
    Navigator.of(context).pushNamed(Routes.register.toString());
  }
}
