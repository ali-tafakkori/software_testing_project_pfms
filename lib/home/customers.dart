import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:software_testing_project_pfms/db/app_database.dart';
import 'package:software_testing_project_pfms/models/customer.dart';
import 'package:software_testing_project_pfms/widgets/app_button.dart';
import 'package:software_testing_project_pfms/widgets/app_text_field.dart';

class CustomerDialog extends StatefulWidget {
  final Customer? customer;

  const CustomerDialog({
    super.key,
    this.customer = const Customer(name: ""),
  });

  @override
  State<CustomerDialog> createState() => _CustomerDialogState();

  static Future<Customer?> show(BuildContext context, [Customer? customer]) {
    return showGeneralDialog<Customer?>(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return CustomerDialog(
          customer: customer,
        );
      },
    );
  }
}

class _CustomerDialogState extends State<CustomerDialog> {
  late final _atfcName = AppTextFieldController(
    text: widget.customer?.name,
  );
  late final _atfcBalance = AppTextFieldController(
    text: widget.customer?.balance == null || widget.customer?.balance == 0
        ? ""
        : widget.customer?.balance.toString(),
  );

  bool obscurePass = true;
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
                  Container(
                    height: 1,
                    color: Colors.black26,
                  ),
                  AppTextField(
                    controller: _atfcBalance,
                    inputType: TextInputType.number,
                    noBorder: true,
                    hintText: "Balance (Default: Zero)",
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
    if (_atfcBalance.text.trim().isEmpty) {
      _atfcBalance.text = "0";
    }
    Navigator.of(context).pop(
      Customer(
        id: widget.customer?.id,
        name: _atfcName.text.trim(),
        balance: int.parse(
          _atfcBalance.text.trim(),
        ),
      ),
    );
  }
}

class Customers extends StatefulWidget {
  const Customers({super.key});

  @override
  State<Customers> createState() => _CustomersState();
}

class _CustomersState extends State<Customers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          CustomerDialog.show(context).then(
            (value) async {
              if (value != null) {
                await AppDatabase.instance.customerDao.insert(value);
                setState(() {});
              }
            },
          );
        },
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: FutureBuilder(
            future: AppDatabase.instance.customerDao.findAll(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isEmpty) {
                  return const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.person_off_rounded,
                        size: 80,
                        color: Colors.black45,
                      ),
                      Text(
                        "No Customer",
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
                      Customer customer = snapshot.data![i];
                      return Card(
                        child: ListTile(
                          leading: const Icon(
                            Icons.person,
                            color: Colors.amber,
                            size: 30,
                          ),
                          title: Text(customer.name),
                          subtitle: Text(
                            "${customer.balance >= 0 ? "+" : ""} ${customer.balance.toString()} \$",
                            style: TextStyle(
                              color: customer.balance >= 0
                                  ? customer.balance == 0
                                  ? null
                                  : Colors.green
                                  : Colors.redAccent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  CustomerDialog.show(
                                    context,
                                    customer,
                                  ).then(
                                    (value) async {
                                      if (value != null) {
                                        await AppDatabase.instance.customerDao
                                            .update(value);
                                        setState(() {});
                                      }
                                    },
                                  );
                                },
                                icon: const Icon(
                                  Icons.edit_outlined,
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  await AppDatabase.instance.customerDao
                                      .deleteById(customer.id!);
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
              return LoadingAnimationWidget.inkDrop(
                color: Colors.amber,
                size: 48,
              );
            },
          ),
        ),
      )),
    );
  }
}
