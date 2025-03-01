import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:software_testing_project_pfms/db/app_database.dart';
import 'package:software_testing_project_pfms/models/user.dart';
import 'package:software_testing_project_pfms/widgets/app_progress_button.dart';
import 'package:software_testing_project_pfms/widgets/app_text_field.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _atfcName = AppTextFieldController();
  final _atfcUser = AppTextFieldController();
  final _atfcPass = AppTextFieldController();
  final _atfcRepeatPass = AppTextFieldController();

  bool obscurePass = true;
  bool obscureRepeatPass = true;
  bool hasFocus = false;
  String? warning;

  AppProgressButtonState state = AppProgressButtonState.idle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
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
                CupertinoIcons.person_add,
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
                      key: const Key("name"),
                      controller: _atfcName,
                      inputType: TextInputType.text,
                      hintText: "نام",
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
                      key: const Key("username"),
                      controller: _atfcUser,
                      inputType: TextInputType.text,
                      hintText: "نام کاربری",
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
                      hintText: "رمز عبور",
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
                    Container(
                      height: 1,
                      color: Colors.black26,
                    ),
                    AppTextField(
                      key: const Key("repeat password"),
                      obscure: obscureRepeatPass,
                      controller: _atfcRepeatPass,
                      inputType: TextInputType.text,
                      noBorder: true,
                      hintText: "تکرار رمز عبور",
                      width: double.infinity,
                      suffixIcon: _atfcRepeatPass.text.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  obscureRepeatPass = !obscureRepeatPass;
                                });
                              },
                              icon: Icon(
                                obscureRepeatPass
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
                key: const Key("register"),
                text: "ثبت نام",
                onPressed: onRegisterPressed,
                state: state,
                color:
                    _atfcUser.text.isNotEmpty ? Colors.amber : Colors.blueGrey,
              ),
            ],
          ),
        )),
      ),
    );
  }

  void onRegisterPressed() async {
    var name = _atfcName.text.trim();
    var username = _atfcUser.text.trim();
    var password = _atfcPass.text.trim();
    var repeatPassword = _atfcRepeatPass.text.trim();
    FocusScope.of(context).children.forEach((FocusNode f) {
      f.unfocus();
    });
    if (name.length < 3) {
      hasFocus = true;
      warning = "نام الزامی است.";
      _atfcName.requestFocus(context);
    } else if (username.length < 3) {
      hasFocus = true;
      warning = "نام کاربری الزامی است";
      _atfcUser.requestFocus(context);
    } else if (password.length < 5) {
      hasFocus = true;
      warning = "رمز عبور الزامی است";
      _atfcPass.requestFocus(context);
    } else if (password != repeatPassword) {
      hasFocus = true;
      warning = "تکرار رمز عبور با رمز عبور مطابقت ندارد.";
      _atfcRepeatPass.requestFocus(context);
    } else {
      setState(() {
        state = AppProgressButtonState.loading;
        warning = null;
      });
      User? user = await AppDatabase.instance.userDao.findByUsername(username);
      if (user == null) {
        await AppDatabase.instance.userDao.insert(User(
          username: username,
          password: password,
          name: name,
        ));
        if (mounted) {
          Navigator.of(context).pop(true);
        }
      } else {
        hasFocus = true;
        warning = "نام کاربری قبلاً استفاده شده است.";
      }
      state = AppProgressButtonState.idle;
    }
    setState(() {});
  }
}
