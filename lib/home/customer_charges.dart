import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:software_testing_project_pfms/db/app_database.dart';
import 'package:software_testing_project_pfms/home/charge_dialog.dart';
import 'package:software_testing_project_pfms/models/charge.dart';
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add_rounded,
        ),
        onPressed: () {
          ChargeDialog.show(
            context,
            widget.id,
          ).then(
            (value) async {
              if (value != null) {
                await AppDatabase.instance.chargeDao.insert(value);
                await AppDatabase.instance.customerDao.chargeBalanceById(
                  value.amount,
                  widget.id,
                );
                setState(() {});
              }
            },
          );
        },
      ),
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder(
            future: AppDatabase.instance.chargeDao.findByCustomerId(widget.id),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var chargeList = snapshot.data!;
                if (chargeList.isEmpty) {
                  return const SizedBox.expand(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: chargeList.length,
                    itemBuilder: (context, i) {
                      Charge charge = chargeList[i];
                      return Card(
                        color: charge.amount >= 0
                            ? charge.amount == 0
                                ? null
                                : Colors.green
                            : Colors.redAccent,
                        child: ListTile(
                          leading: Icon(
                            charge.amount >= 0
                                ? charge.amount == 0
                                    ? null
                                    : Icons.add_circle_outline_rounded
                                : Icons.remove_circle_outline_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                          title: Text(
                            NumberFormat.simpleCurrency(decimalDigits: 0)
                                .format(charge.amount.abs()),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          trailing: Text(
                            formatCompactDate(charge.dateTime),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          /*trailing: IconButton(
                            onPressed: () async {
                              await AppDatabase.instance.chargeDao
                                  .deleteById(charge.id!);
                              await AppDatabase.instance.customerDao
                                  .chargeBalanceById(
                                charge.amount * -1,
                                widget.id,
                              );
                              setState(() {});
                            },
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.white,
                            ),
                          ),*/
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
      ),
    );
  }
}
