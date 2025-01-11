import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:software_testing_project_pfms/db/app_database.dart';
import 'package:software_testing_project_pfms/main.dart';
import 'package:software_testing_project_pfms/models/user.dart';
import 'package:software_testing_project_pfms/widgets/app_button.dart';
import 'package:software_testing_project_pfms/widgets/app_text_field.dart';

class NameDialog extends StatefulWidget {
  final String name;

  const NameDialog({
    super.key,
    required this.name,
  });

  @override
  State<NameDialog> createState() => _NameDialogState();

  static Future<String?> show(
    BuildContext context,
    String name,
  ) {
    return showGeneralDialog<String?>(
      context: context,
      barrierDismissible: true,
      barrierLabel: "",
      pageBuilder: (context, animation, secondaryAnimation) {
        return NameDialog(
          name: name,
        );
      },
    );
  }
}

class _NameDialogState extends State<NameDialog> {
  late final _atfcName = AppTextFieldController(
    text: widget.name,
  );

  bool hasFocus = false;
  String? warning;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
                    controller: _atfcName,
                    inputType: TextInputType.text,
                    hintText: "Name",
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
            AppButton(
              text: "Save",
              onPressed: onSavePressed,
              color: _atfcName.text.isNotEmpty ? Colors.amber : Colors.blueGrey,
            ),
          ],
        ),
      ),
    );
  }

  void onSavePressed() {
    var name = _atfcName.text.trim();
    FocusScope.of(context).children.forEach((FocusNode f) {
      f.unfocus();
    });
    if (name.length < 3) {
      hasFocus = true;
      warning = "Name is required.";
      _atfcName.requestFocus(context);
    } else {
      Navigator.of(context).pop(name);
    }
    setState(() {});
  }
}

class UsernameDialog extends StatefulWidget {
  final String username;

  const UsernameDialog({
    super.key,
    required this.username,
  });

  @override
  State<UsernameDialog> createState() => _UsernameDialogState();

  static Future<String?> show(
    BuildContext context,
    String username,
  ) {
    return showGeneralDialog<String?>(
      context: context,
      barrierDismissible: true,
      barrierLabel: "",
      pageBuilder: (context, animation, secondaryAnimation) {
        return UsernameDialog(
          username: username,
        );
      },
    );
  }
}

class _UsernameDialogState extends State<UsernameDialog> {
  late final _atfcUsername = AppTextFieldController(
    text: widget.username,
  );

  bool hasFocus = false;
  String? warning;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
                    controller: _atfcUsername,
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
            AppButton(
              text: "Save",
              onPressed: onSavePressed,
              color: _atfcUsername.text.isNotEmpty
                  ? Colors.amber
                  : Colors.blueGrey,
            ),
          ],
        ),
      ),
    );
  }

  void onSavePressed() {
    var username = _atfcUsername.text.trim();
    FocusScope.of(context).children.forEach((FocusNode f) {
      f.unfocus();
    });
    if (username.length < 3) {
      hasFocus = true;
      warning = "Username is required.";
      _atfcUsername.requestFocus(context);
    } else {
      Navigator.of(context).pop(username);
    }
    setState(() {});
  }
}

class PasswordDialog extends StatefulWidget {
  const PasswordDialog({super.key});

  @override
  State<PasswordDialog> createState() => _PasswordDialogState();

  static Future<String?> show(
    BuildContext context,
    String username,
  ) {
    return showGeneralDialog<String?>(
      context: context,
      barrierDismissible: true,
      barrierLabel: "",
      pageBuilder: (context, animation, secondaryAnimation) {
        return const PasswordDialog();
      },
    );
  }
}

class _PasswordDialogState extends State<PasswordDialog> {
  final _atfcPass = AppTextFieldController();
  final _atfcRepeatPass = AppTextFieldController();

  bool obscurePass = true;
  bool obscureRepeatPass = true;
  bool hasFocus = false;
  String? warning;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
                  Container(
                    height: 1,
                    color: Colors.black26,
                  ),
                  AppTextField(
                    obscure: obscureRepeatPass,
                    controller: _atfcRepeatPass,
                    inputType: TextInputType.text,
                    noBorder: true,
                    hintText: "Repeat Password",
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
            AppButton(
              text: "Save",
              onPressed: onSavePressed,
              color: _atfcPass.text.isNotEmpty ? Colors.amber : Colors.blueGrey,
            ),
          ],
        ),
      ),
    );
  }

  void onSavePressed() {
    var password = _atfcPass.text.trim();
    var repeatPassword = _atfcRepeatPass.text.trim();
    FocusScope.of(context).children.forEach((FocusNode f) {
      f.unfocus();
    });
    if (password.length < 5) {
      hasFocus = true;
      warning = "Password is required.";
      _atfcPass.requestFocus(context);
    } else if (password != repeatPassword) {
      hasFocus = true;
      warning = "Repeat Password does not match Password.";
      _atfcRepeatPass.requestFocus(context);
    } else {
      Navigator.of(context).pop(password);
    }
    setState(() {});
  }
}

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: FutureBuilder<User?>(
          future:
              AppDatabase.instance.userDao.findById(MyApp.of(context)!.userId!),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              User user = snapshot.data!;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top + 24,
                        bottom: MediaQuery.of(context).padding.top + 24,
                      ),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(
                            24,
                          ),
                        ),
                        color: Colors.amber,
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(
                              14,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(125),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              CupertinoIcons.person,
                              color: Colors.white,
                              size: 60,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            user.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            user.username,
                            style: const TextStyle(
                              color: Colors.white54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          Card(
                            child: ListTile(
                              leading: const Icon(
                                Icons.abc,
                              ),
                              title: const Text(
                                "Edit Name",
                              ),
                              trailing: const Icon(Icons.arrow_forward),
                              onTap: () {
                                NameDialog.show(context, user.name).then(
                                  (value) async {
                                    if (value != null) {
                                      await AppDatabase.instance.userDao
                                          .updateNameById(
                                        value,
                                        user.id!,
                                      );
                                      setState(() {});
                                    }
                                  },
                                );
                              },
                            ),
                          ),
                          Card(
                            child: ListTile(
                              leading: const Icon(
                                Icons.alternate_email_outlined,
                              ),
                              title: const Text(
                                "Edit Username",
                              ),
                              trailing: const Icon(Icons.arrow_forward),
                              onTap: () {
                                UsernameDialog.show(context, user.username)
                                    .then(
                                  (value) async {
                                    if (value != null) {
                                      await AppDatabase.instance.userDao
                                          .updateUsernameById(
                                        value,
                                        user.id!,
                                      );
                                      setState(() {});
                                    }
                                  },
                                );
                              },
                            ),
                          ),
                          Card(
                            child: ListTile(
                              leading: const Icon(
                                Icons.vpn_key_outlined,
                              ),
                              title: const Text(
                                "Change Password",
                              ),
                              trailing: const Icon(Icons.arrow_forward),
                              onTap: () {
                                PasswordDialog.show(context, user.name).then(
                                  (value) async {
                                    if (value != null) {
                                      await AppDatabase.instance.userDao
                                          .updatePasswordById(
                                        value,
                                        user.id!,
                                      );
                                      setState(() {});
                                    }
                                  },
                                );
                              },
                            ),
                          ),
                          const Divider(),
                          Card(
                            child: ListTile(
                              leading: const Icon(
                                Icons.logout,
                              ),
                              title: const Text(
                                "Logout",
                              ),
                              trailing: const Icon(Icons.arrow_forward),
                              onTap: () {
                                Navigator.of(context).pop();
                                MyApp.of(context)?.userId = null;
                              },
                            ),
                          ),
                          /*Card(
                            color: Colors.redAccent,
                            child: ListTile(
                              leading: const Icon(
                                Icons.delete_outlined,
                                color: Colors.white,
                              ),
                              title: const Text(
                                "Delete Account",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              ),
                              onTap: () {},
                            ),
                          ),*/
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
            return LoadingAnimationWidget.newtonCradle(
              color: Colors.black,
              size: 53,
            );
          }),
    );
  }
}
