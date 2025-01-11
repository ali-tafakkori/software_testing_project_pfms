import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:software_testing_project_pfms/db/app_database.dart';
import 'package:software_testing_project_pfms/main.dart';
import 'package:software_testing_project_pfms/models/user.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 24,
                bottom: 16,
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
                      color: Colors.black,
                      size: 60,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  FutureBuilder<User?>(
                    future: AppDatabase.instance.userDao
                        .findById(MyApp.of(context)!.userId!),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              snapshot.data!.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              snapshot.data!.username,
                              style: const TextStyle(
                                color: Colors.white54,
                              ),
                            ),
                          ],
                        );
                      }
                      return LoadingAnimationWidget.newtonCradle(
                        color: Colors.black,
                        size: 53,
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
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
                      onTap: () {},
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
                      onTap: () {},
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
                      onTap: () {},
                    ),
                  ),
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
                  const Divider(),
                  Card(
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
