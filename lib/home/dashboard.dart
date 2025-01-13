import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:software_testing_project_pfms/db/app_database.dart';
import 'package:software_testing_project_pfms/main.dart';
import 'package:software_testing_project_pfms/models/purchase.dart';
import 'package:software_testing_project_pfms/router.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 24,
              bottom: 24,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LoadingAnimationWidget.halfTriangleDot(
                  color: Colors.white54,
                  size: 80,
                ),
                SizedBox(
                  height: MediaQuery.of(context).padding.top + 24,
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
                            color: Colors.white54,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: FutureBuilder(
                              future: AppDatabase.instance.customerDao
                                  .countByUserId(
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
                            color: Colors.white54,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: FutureBuilder(
                              future: AppDatabase.instance
                                  .profit(MyApp.of(context)!.userId!),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  double i = snapshot.data!;
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
                            color: Colors.white54,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: FutureBuilder(
                              future: AppDatabase.instance
                                  .debt(MyApp.of(context)!.userId!),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  int i = snapshot.data!;
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
            child: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Center(
                  child: FutureBuilder(
                    future: AppDatabase.instance.findPurchases(
                      MyApp.of(context)!.userId!,
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
                              var purchase = snapshot.data![i];
                              return Card(
                                child: ListTile(
                                  leading: const Icon(
                                    Icons.view_headline_outlined,
                                  ),
                                  title: Text(NumberFormat.simpleCurrency(
                                          decimalDigits: 0)
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
                                      return LoadingAnimationWidget
                                          .progressiveDots(
                                        color: Colors.black,
                                        size: 24,
                                      );
                                    },
                                  ),
                                  trailing: Text(
                                    DateFormat("yyyy/MM/dd")
                                        .format(purchase.dateTime),
                                  ),
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                      Routes.purchaseDetails.toString(),
                                      arguments: {
                                        "customerId": purchase.customerId,
                                        "dateTime": purchase.dateTime,
                                      },
                                    );
                                  },
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
          ),
        ],
      ),
    );
  }
}
