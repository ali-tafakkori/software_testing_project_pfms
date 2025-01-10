import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:software_testing_project_pfms/db/app_database.dart';
import 'package:software_testing_project_pfms/main.dart';
import 'package:software_testing_project_pfms/models/purchase.dart';
import 'package:software_testing_project_pfms/models/user.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 350,
          color: Colors.amber,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 24,
            bottom: 24,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
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
                            future:
                                AppDatabase.instance.customerDao.countByUserId(
                              MyApp.of(context)!.userId!,
                            ),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                int i = snapshot.data as int;
                                Color color =
                                    i > 0 ? Colors.black : Colors.redAccent;
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      CupertinoIcons.person_2,
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
                              "SELECT (IFNULL((SELECT SUM(balance) FROM customer WHERE userId = ?1), 0) - IFNULL((SELECT SUM(amount) FROM invoice WHERE userId = ?1), 0) - (IFNULL((SELECT SUM(amount) FROM invoice WHERE userId = ?1), 0) * 0.1)) AS profit",
                              [
                                MyApp.of(context)!.userId!,
                              ],
                            ),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                var row =
                                    snapshot.data!.first.values.first ?? 0;
                                double i = row as double;
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
                              "SELECT (IFNULL((SELECT SUM(balance) FROM customer WHERE userId = ?1), 0) - IFNULL((SELECT SUM(amount) FROM invoice WHERE userId = ?1), 0)) AS difference",
                              [
                                MyApp.of(context)!.userId!,
                              ],
                            ),
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
                                      i >= 0
                                          ? i == 0
                                              ? Icons.balance
                                              : Icons.trending_up
                                          : Icons.trending_down,
                                      color: color,
                                      size: 30,
                                    ),
                                    Text(
                                      (i > 0 ? "+" : "") +
                                          NumberFormat.compact()
                                              .format(i.abs()),
                                      style: TextStyle(
                                        color: color,
                                        fontSize: 17,
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
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: FutureBuilder(
                future: AppDatabase.instance.database.rawQuery(
                  "SELECT t1.*,t2.name FROM invoice AS t1 INNER JOIN customer AS t2 ON t1.userId = t2.id WHERE t1.userId = ?1",
                  [
                    MyApp.of(context)!.userId!,
                  ],
                ),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) {
                      return const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.grid_off,
                            size: 80,
                            color: Colors.black45,
                          ),
                          Text(
                            "No Purchase",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      );
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, i) {
                          var map = snapshot.data![i];
                          Purchase purchase = Purchase(
                            amount: map["amount"] as int,
                            dateTime: DateTime.parse(map["dateTime"] as String),
                            customerId: map["customerId"] as int,
                          );
                          return Card(
                            child: ListTile(
                              leading: Text(
                                DateFormat("yyyy/MM/dd")
                                    .format(purchase.dateTime),
                              ),
                              title: Text(
                                  NumberFormat.simpleCurrency(decimalDigits: 0)
                                      .format(purchase.amount)),
                              subtitle: FutureBuilder(
                                future: AppDatabase.instance.customerDao
                                    .findById(purchase.customerId),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(
                                      snapshot.data!.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    );
                                  }
                                  return LoadingAnimationWidget.progressiveDots(
                                    color: Colors.black,
                                    size: 24,
                                  );
                                },
                              ),
                              trailing: IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.view_headline_outlined,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  }
                  return LoadingAnimationWidget.inkDrop(
                    color: Colors.amber,
                    size: 48,
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
