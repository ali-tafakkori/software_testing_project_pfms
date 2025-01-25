import 'package:currency_textfield/currency_textfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ir_datetime_picker/ir_datetime_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:software_testing_project_pfms/db/app_database.dart';
import 'package:software_testing_project_pfms/main.dart';
import 'package:software_testing_project_pfms/models/customer.dart';
import 'package:software_testing_project_pfms/models/invoice.dart';
import 'package:software_testing_project_pfms/router.dart';
import 'package:software_testing_project_pfms/utils.dart';
import 'package:software_testing_project_pfms/widgets/app_button.dart';
import 'package:software_testing_project_pfms/widgets/app_text_field.dart';

class CustomerListDialog extends StatefulWidget {
  final int userId;
  final int selectedId;

  const CustomerListDialog({
    super.key,
    required this.userId,
    required this.selectedId,
  });

  @override
  State<CustomerListDialog> createState() => _CustomerListDialogState();

  static Future<Customer?> show(
    BuildContext context,
    int userId,
    int selectedId,
  ) {
    return showGeneralDialog<Customer?>(
      context: context,
      barrierDismissible: true,
      barrierLabel: "",
      pageBuilder: (context, animation, secondaryAnimation) {
        return CustomerListDialog(
          userId: userId,
          selectedId: selectedId,
        );
      },
    );
  }
}

class _CustomerListDialogState extends State<CustomerListDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder(
          future: AppDatabase.instance.customerDao.findByUserId(
            widget.userId,
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
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black.withAlpha(5),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        for (Customer customer in snapshot.data!) ...[
                          ListTile(
                            tileColor: customer.id == widget.selectedId
                                ? Colors.amber
                                : null,
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
                            onTap: () {
                              Navigator.of(
                                context,
                                rootNavigator: true,
                              ).pop(
                                customer,
                              );
                            },
                          ),
                          if (snapshot.data!.last != customer)
                            Container(
                              height: 1,
                              color: Colors.black26,
                            ),
                        ]
                      ],
                    ),
                  ),
                );
              }
            }
            return LoadingAnimationWidget.inkDrop(
              color: Colors.black,
              size: 30,
            );
          },
        ),
      ),
    );
  }
}

class InvoiceDialog extends StatefulWidget {
  final Invoice invoice;

  const InvoiceDialog({
    super.key,
    required this.invoice,
  });

  @override
  State<InvoiceDialog> createState() => _InvoiceDialogState();

  static Future<Invoice?> show(BuildContext context, Invoice invoice) {
    return showGeneralDialog<Invoice?>(
      context: context,
      barrierDismissible: true,
      barrierLabel: "",
      pageBuilder: (context, animation, secondaryAnimation) {
        return InvoiceDialog(
          invoice: invoice,
        );
      },
    );
  }
}

class _InvoiceDialogState extends State<InvoiceDialog> {
  late int customerId;
  final _atfcCustomer = AppTextFieldController();
  late DateTime dateTime = widget.invoice.dateTime;
  late final _atfcDateTime = AppTextFieldController(
    text: formatCompactDate(dateTime),
  );
  final _cAmount = CurrencyTextFieldController(
    decimalSymbol: ".",
    thousandSymbol: ",",
    numberOfDecimals: 0,
    currencySymbol: "\$",
    enableNegative: false,
  );
  late final _atfcAmount = AppTextFieldController(
    controller: _cAmount,
  );

  bool hasFocus = false;
  String? warning;

  @override
  void initState() {
    AppDatabase.instance.customerDao
        .findById(
      widget.invoice.customerId,
    )
        .then(
      (value) {
        if (value != null) {
          _atfcCustomer.text = value.name;
          setState(() {
            customerId = value.id!;
          });
        }
      },
    );

    _atfcAmount.text =
        (widget.invoice.amount == 0 ? "" : widget.invoice.amount.toString());
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
                    key: const Key("invoice customer"),
                    controller: _atfcCustomer,
                    inputType: TextInputType.text,
                    hintText: "مشتری",
                    noBorder: true,
                    width: double.infinity,
                    readOnly: true,
                    onTap: onCustomerTap,
                    prefixIcon: const Icon(
                      Icons.person_outline_rounded,
                    ),
                  ),
                  Container(
                    height: 1,
                    color: Colors.black26,
                  ),
                  AppTextField(
                    controller: _atfcDateTime,
                    inputType: TextInputType.text,
                    hintText: "تاریخ",
                    noBorder: true,
                    width: double.infinity,
                    readOnly: true,
                    onTap: onDateTimeTap,
                    prefixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          dateTime = DateTime.now();
                          _atfcDateTime.text = formatCompactDate(dateTime);
                        });
                      },
                      icon: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 2,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: Colors.black,
                            width: 1.2,
                          ),
                        ),
                        child: const Text("Now"),
                      ),
                    ),
                  ),
                  Container(
                    height: 1,
                    color: Colors.black26,
                  ),
                  AppTextField(
                    key: const Key("amount"),
                    controller: _atfcAmount,
                    inputType: TextInputType.number,
                    noBorder: true,
                    hintText: "مبلغ (پیش فرض: صفر)",
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
            const SizedBox(
              height: 40,
            ),
            AppButton(
              key: const Key("save"),
              text: "ذخیره",
              onPressed: onSavePressed,
              color: _atfcDateTime.text.isEmpty && _atfcAmount.text.isEmpty
                  ? Colors.blueGrey
                  : Colors.amber,
            ),
          ],
        ),
      ),
    );
  }

  void onCustomerTap() {
    CustomerListDialog.show(
      context,
      widget.invoice.userId,
      widget.invoice.customerId,
    ).then(
      (value) {
        if (value != null) {
          _atfcCustomer.text = value.name;
          setState(() {
            customerId = value.id!;
          });
        }
      },
    );
  }

  void onDateTimeTap() {
    showIRJalaliDatePickerDialog(
      context: context,
      title: "انتخاب تاریخ",
      visibleTodayButton: true,
      todayButtonText: "انتخاب امروز",
      confirmButtonText: "تایید",
      initialDate: Jalali.fromDateTime(dateTime),
    ).then(
      (value) {
        if (value != null) {
          setState(() {
            dateTime = value.toDateTime();
            _atfcDateTime.text = formatCompactDate(dateTime);
          });
        }
      },
    );
  }

  void onSavePressed() {
    if (_atfcAmount.text.trim().isEmpty) {
      _atfcAmount.text = "0";
    }
    Navigator.of(context).pop(
      Invoice(
        id: widget.invoice.id,
        dateTime: dateTime,
        amount: _cAmount.intValue,
        customerId: customerId,
        userId: MyApp.of(context)!.userId!,
      ),
    );
  }
}

class Invoices extends StatefulWidget {
  const Invoices({super.key});

  @override
  State<Invoices> createState() => _InvoicesState();
}

class _InvoicesState extends State<Invoices> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        key: const Key("new invoice"),
        child: const Icon(
          Icons.add_rounded,
        ),
        onPressed: () {
          InvoiceDialog.show(
              context,
              Invoice(
                amount: 0,
                dateTime: DateTime.now(),
                customerId: -1,
                userId: MyApp.of(context)!.userId!,
              )).then(
            (value) async {
              if (value != null) {
                await AppDatabase.instance.invoiceDao.insert(value);
                await AppDatabase.instance.customerDao.chargeBalanceById(
                  value.amount * -1,
                  value.customerId,
                );
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
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                Routes.invoiceDetails.toString(),
                                arguments: {
                                  "id": invoice.id,
                                },
                              );
                            },
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
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(formatCompactDate(invoice.dateTime)),
                                FutureBuilder(
                                  future: AppDatabase.instance.customerDao
                                      .findById(invoice.customerId),
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
                                )
                              ],
                            ),
                            title: Text(
                              NumberFormat.simpleCurrency(decimalDigits: 0)
                                  .format(invoice.amount),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    InvoiceDialog.show(
                                      context,
                                      invoice,
                                    ).then(
                                      (value) async {
                                        if (value != null) {
                                          await AppDatabase.instance.invoiceDao
                                              .update(value);
                                          await AppDatabase.instance.customerDao
                                              .chargeBalanceById(
                                            (value.amount - invoice.amount) *
                                                -1,
                                            value.customerId,
                                          );
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
                                    await AppDatabase.instance.invoiceDao
                                        .deleteById(invoice.id!);
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
        ),
      ),
    );
  }
}
