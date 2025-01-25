import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:software_testing_project_pfms/db/app_database.dart';
import 'package:software_testing_project_pfms/models/charge.dart';
import 'package:software_testing_project_pfms/router.dart';
import 'package:software_testing_project_pfms/utils.dart';

class CustomerCharges extends StatefulWidget {
  final int id;

  const CustomerCharges({
    super.key,
    required this.id,
  });

  @override
  State<CustomerCharges> createState() => _CustomerChargesState();
}

class _CustomerChargesState extends State<CustomerCharges> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: FutureBuilder(
          future: AppDatabase.instance.customerDao.findById(widget.id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListTile(
                subtitle: Text(snapshot.data!.name),
                title: Text(
                  NumberFormat.simpleCurrency(decimalDigits: 0)
                      .format(snapshot.data!.balance),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }
            return LoadingAnimationWidget.progressiveDots(
              color: Colors.black,
              size: 24,
            );
          },
        ),
      ),
      body: FutureBuilder(
          future: AppDatabase.instance.chargeDao.findByCustomerId(widget.id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var chargeList = snapshot.data!;
              if (chargeList.isEmpty) {
                return const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.folder_off_rounded,
                      size: 80,
                      color: Colors.black45,
                    ),
                    Text(
                      "بدون تاریخچه شارژر",
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
                  itemCount: chargeList.length,
                  itemBuilder: (context, i) {
                    Charge charge = chargeList[i];
                    return Card(
                      child: ListTile(
                        leading: const Icon(
                          Icons.person,
                          color: Colors.amber,
                          size: 30,
                        ),
                        title: Text(
                          "${charge.amount > 0 ? "+" : ""} ${NumberFormat.simpleCurrency(decimalDigits: 0).format(charge.amount)}",
                          style: TextStyle(
                            color: charge.amount >= 0
                                ? charge.amount == 0
                                    ? null
                                    : Colors.green
                                : Colors.redAccent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(formatCompactDate(charge.dateTime)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () async {
                                await AppDatabase.instance.chargeDao
                                    .deleteById(charge.id!);
                                setState(() {});
                              },
                              icon: const Icon(
                                Icons.delete_outline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            }
            return Center(
              child: LoadingAnimationWidget.inkDrop(
                color: Colors.amber,
                size: 48,
              ),
            );
          }),
    );
  }
}
