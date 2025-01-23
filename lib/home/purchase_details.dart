import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:software_testing_project_pfms/db/app_database.dart';
import 'package:software_testing_project_pfms/main.dart';
import 'package:software_testing_project_pfms/models/invoice.dart';

class PurchaseDetails extends StatefulWidget {
  final int customerId;
  final DateTime dateTime;

  const PurchaseDetails({
    super.key,
    required this.customerId,
    required this.dateTime,
  });

  @override
  State<PurchaseDetails> createState() => _PurchaseDetailsState();
}

class _PurchaseDetailsState extends State<PurchaseDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: ListTile(
          title: FutureBuilder(
            future: AppDatabase.instance.userDao.findById(
              widget.customerId,
            ),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(
                  snapshot.data!.name,
                );
              }
              return LoadingAnimationWidget.progressiveDots(
                color: Colors.black,
                size: 24,
              );
            },
          ),
          subtitle: Text(
            DateFormat("yyyy/MM/dd").format(widget.dateTime),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: FutureBuilder(
            future: AppDatabase.instance.invoiceDao.findByUserId(
              MyApp.of(context)!.userId!,
            ),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isEmpty) {
                  return const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.folder_off_rounded,
                        size: 80,
                        color: Colors.black45,
                      ),
                      Text(
                        "بدون فاکتور",
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
                      Invoice invoice = snapshot.data![i];
                      return Card(
                        child: ListTile(
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(
                                  50,
                                )),
                            child: Center(
                              child: Text(
                                invoice.id.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            NumberFormat.simpleCurrency(decimalDigits: 0)
                                .format(invoice.amount),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
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
    );
  }
}
