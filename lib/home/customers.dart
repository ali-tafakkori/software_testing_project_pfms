import 'package:currency_textfield/currency_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:software_testing_project_pfms/db/app_database.dart';
import 'package:software_testing_project_pfms/home/charge_dialog.dart';
import 'package:software_testing_project_pfms/main.dart';
import 'package:software_testing_project_pfms/models/charge.dart';
import 'package:software_testing_project_pfms/models/customer.dart';
import 'package:software_testing_project_pfms/router.dart';
import 'package:software_testing_project_pfms/widgets/app_button.dart';
import 'package:software_testing_project_pfms/widgets/app_text_field.dart';
import 'package:intl/intl.dart';

class CustomerDialog extends StatefulWidget {
  final Customer customer;

  const CustomerDialog({
    super.key,
    required this.customer,
  });

  @override
  State<CustomerDialog> createState() => _CustomerDialogState();

  static Future<Customer?> show(BuildContext context, Customer customer) {
    return showGeneralDialog<Customer?>(
      context: context,
      barrierDismissible: true,
      barrierLabel: "",
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
    text: widget.customer.name,
  );

  final _cBalance = CurrencyTextFieldController(
    decimalSymbol: ".",
    thousandSymbol: ",",
    numberOfDecimals: 0,
    currencySymbol: "\$",
    enableNegative: false,
  );
  late final _atfcBalance = AppTextFieldController(
    controller: _cBalance,
  );

  late bool negativeBalance = (widget.customer.balance) < 0;

  bool obscurePass = true;
  bool hasFocus = false;
  String? warning;

  @override
  void initState() {
    _atfcBalance.text = (widget.customer.balance == 0
        ? ""
        : widget.customer.balance.toString());
    super.initState();
  }

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
                    key: const Key("name"),
                    controller: _atfcName,
                    inputType: TextInputType.text,
                    hintText: "نام",
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
                  if (widget.customer.id == null) ...[
                    Container(
                      height: 1,
                      color: Colors.black26,
                    ),
                    AppTextField(
                      key: const Key("balance"),
                      controller: _atfcBalance,
                      inputType: TextInputType.number,
                      noBorder: true,
                      hintText: "تراز (پیش‌فرض: صفر)",
                      width: double.infinity,
                      prefixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            negativeBalance = !negativeBalance;
                          });
                        },
                        icon: Icon(
                          negativeBalance
                              ? Icons.remove_circle_outline_rounded
                              : Icons.add_circle_outline_rounded,
                        ),
                      ),
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
              key: const Key("save"),
              text: "ذخیره",
              onPressed: onSavePressed,
              color: _atfcName.text.isNotEmpty ? Colors.amber : Colors.blueGrey,
            ),
          ],
        ),
      ),
    );
  }

  void onSavePressed() {
    int intValue = _cBalance.intValue;
    if (_atfcBalance.text.trim().isEmpty) {
      _atfcBalance.text = "0";
    } else if (negativeBalance) {
      intValue *= -1;
    }
    Navigator.of(context).pop(
      Customer(
        id: widget.customer.id,
        name: _atfcName.text.trim(),
        balance: intValue,
        userId: MyApp.of(context)!.userId!,
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
        key: const Key("new customer"),
        child: const Icon(
          Icons.add_rounded,
        ),
        onPressed: () {
          CustomerDialog.show(
            context,
            Customer(
              name: "",
              userId: MyApp.of(context)!.userId!,
            ),
          ).then(
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
            future: AppDatabase.instance.customerDao.findByUserId(
              MyApp.of(context)!.userId!,
            ),
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
                        "بدون مشتری",
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
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              Routes.customerCharges.toString(),
                              arguments: {
                                "id": customer.id,
                              },
                            ).then(
                              (value) {
                                setState(() {});
                              },
                            );
                          },
                          leading: const Icon(
                            Icons.person,
                            color: Colors.amber,
                            size: 30,
                          ),
                          title: Text(customer.name),
                          subtitle: Text(
                            "${customer.balance > 0 ? "+" : ""} ${NumberFormat.simpleCurrency(decimalDigits: 0).format(customer.balance)}",
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
                                onPressed: () {
                                  ChargeDialog.show(
                                    context,
                                    customer.id!,
                                  ).then(
                                    (value) async {
                                      if (value != null) {
                                        await AppDatabase.instance.chargeDao
                                            .insert(value);
                                        await AppDatabase.instance.customerDao
                                            .chargeBalanceById(
                                          value.amount,
                                          customer.id!,
                                        );
                                        setState(() {});
                                      }
                                    },
                                  );
                                },
                                icon: const Icon(
                                  Icons.add_circle_outline_rounded,
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  await AppDatabase.instance.customerDao
                                      .deleteById(customer.id!);
                                  await AppDatabase.instance.chargeDao
                                      .deleteByCustomerId(customer.id!);
                                  await AppDatabase.instance.invoiceDao
                                      .deleteByCustomerId(customer.id!);
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
