import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:software_testing_project_pfms/home/customers.dart';
import 'package:software_testing_project_pfms/home/dashboard.dart';
import 'package:software_testing_project_pfms/home/invoices.dart';
import 'package:software_testing_project_pfms/home/profile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: theme.colorScheme.surfaceContainer,
    ));
    return Scaffold(
      body: <Widget>[
        const Dashboard(),
        const Invoices(),
        const Customers(),
        const Profile(),
      ][currentPageIndex],
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(16),
        ),
        child: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          indicatorColor: Colors.amber,
          selectedIndex: currentPageIndex,
          destinations: const <Widget>[
            NavigationDestination(
              icon: Icon(CupertinoIcons.home),
              label: 'داشبورد',
            ),
            NavigationDestination(
              key: Key("invoices"),
              icon: Icon(CupertinoIcons.list_bullet_below_rectangle),
              label: 'فاکتورها',
            ),
            NavigationDestination(
              key: Key("customers"),
              icon: Icon(CupertinoIcons.person_2),
              label: 'مشتریان',
            ),
            NavigationDestination(
              icon: Icon(CupertinoIcons.profile_circled),
              label: 'نمایه',
            ),
          ],
        ),
      ),
    );
  }
}
