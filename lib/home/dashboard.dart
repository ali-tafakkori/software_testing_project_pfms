import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:software_testing_project_pfms/db/app_database.dart';
import 'package:software_testing_project_pfms/main.dart';
import 'package:software_testing_project_pfms/models/user.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 300,
            color: Colors.amber,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 24,
              bottom: 24,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Center(
                    child: Container(
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.white60,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Center(
                        widthFactor: 1,
                        child: FutureBuilder<User?>(
                          future: AppDatabase.instance.userDao
                              .findById(MyApp.of(context)!.userId!),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                "Hi ${snapshot.data?.name}!",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                ),
                              );
                            }
                            return LoadingAnimationWidget.newtonCradle(
                              color: Colors.black,
                              size: 200,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(125),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: FutureBuilder(
                              future: AppDatabase.instance.customerDao.count(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Text(
                                    snapshot.data.toString(),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 27,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  );
                                }
                                return LoadingAnimationWidget.inkDrop(
                                  color: Colors.black,
                                  size: 30,
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Text(
                          "Customer",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(125),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: FutureBuilder(
                              future: AppDatabase.instance.database.rawQuery(
                                  "SELECT IFNULL(SUM(balance), 0) - IFNULL(SUM(amount), 0) - (IFNULL(SUM(amount), 0) * 0.1) AS profit FROM customer, invoice"),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  var row =
                                      snapshot.data!.first.values.first ?? 0;
                                  double i = row as double;
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        i >= 0
                                            ? i == 0
                                                ? Icons.balance
                                                : Icons.trending_up
                                            : Icons.trending_down,
                                        color: i >= 0
                                            ? i == 0
                                                ? Colors.black
                                                : Colors.green
                                            : Colors.redAccent,
                                        size: 30,
                                      ),
                                      Text(
                                        NumberFormat.compact().format(i),
                                        style: TextStyle(
                                          color: i >= 0
                                              ? i == 0
                                                  ? Colors.black
                                                  : Colors.green
                                              : Colors.redAccent,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ],
                                  );
                                }
                                return LoadingAnimationWidget.inkDrop(
                                  color: Colors.black,
                                  size: 30,
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Text(
                          "Profit",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(125),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: FutureBuilder(
                              future: AppDatabase.instance.database.rawQuery(
                                  "SELECT (IFNULL((SELECT SUM(balance) FROM customer), 0) - IFNULL((SELECT SUM(amount) FROM invoice), 0)) AS difference"),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  var row =
                                      snapshot.data!.first.values.first ?? 0;
                                  int i = row as int;
                                  Color color = i >= 0
                                      ? i == 0
                                          ? Colors.black
                                          : Colors.green
                                      : Colors.redAccent;
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.monetization_on_outlined,
                                        color: color,
                                      ),
                                      Text(
                                        NumberFormat.compact().format(i),
                                        style: TextStyle(
                                          color: color,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ],
                                  );
                                }
                                return LoadingAnimationWidget.inkDrop(
                                  color: Colors.black,
                                  size: 30,
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Text(
                          "Debt",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
