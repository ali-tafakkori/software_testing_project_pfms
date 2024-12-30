import 'package:currency_textfield/currency_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:software_testing_project_pfms/db/app_database.dart';
import 'package:software_testing_project_pfms/models/invoice.dart';
import 'package:software_testing_project_pfms/widgets/app_button.dart';
import 'package:software_testing_project_pfms/widgets/app_text_field.dart';

class InvoiceDialog extends StatefulWidget {
  late final Invoice? invoice;

  InvoiceDialog({
    super.key,
    Invoice? invoice,
  }) {
    this.invoice = invoice ??
        Invoice(
          amount: 0,
          dateTime: DateTime.now(),
        );
  }

  @override
  State<InvoiceDialog> createState() => _InvoiceDialogState();

  static Future<Invoice?> show(BuildContext context, [Invoice? invoice]) {
    return showGeneralDialog<Invoice?>(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return InvoiceDialog(
          invoice: invoice,
        );
      },
    );
  }
}

class _InvoiceDialogState extends State<InvoiceDialog> {
  late DateTime dateTime = widget.invoice!.dateTime;
  late final _atfcDateTime = AppTextFieldController(
    text: DateFormat("yyyy/MM/dd").format(dateTime),
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
    _atfcAmount.text =
        (widget.invoice?.amount == null || widget.invoice?.amount == 0
            ? ""
            : widget.invoice?.amount.toString())!;
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
                    controller: _atfcDateTime,
                    inputType: TextInputType.text,
                    hintText: "Date",
                    noBorder: true,
                    width: double.infinity,
                    readOnly: true,
                    onTap: () {
                      setState(() {
                        hasFocus = true;
                      });
                    },
                    prefixIcon: IconButton(
                      onPressed: () {
                        _atfcDateTime.text =
                            DateFormat("yyyy/MM/dd").format(dateTime);
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
                    controller: _atfcAmount,
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
              color: _atfcDateTime.text.isEmpty && _atfcAmount.text.isEmpty
                  ? Colors.blueGrey
                  : Colors.amber,
            ),
          ],
        ),
      ),
    );
  }

  void onSavePressed() {
    if (_atfcAmount.text.trim().isEmpty) {
      _atfcAmount.text = "0";
    }
    Navigator.of(context).pop(
      Invoice(
        id: widget.invoice?.id,
        dateTime: dateTime,
        amount: _cAmount.intValue,
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
        child: const Icon(Icons.add),
        onPressed: () {
          InvoiceDialog.show(context).then(
            (value) async {
              if (value != null) {
                await AppDatabase.instance.invoiceDao.insert(value);
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
            future: AppDatabase.instance.invoiceDao.findAll(),
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
                        "No Invoice",
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
                          subtitle: Text(DateFormat("yyyy/MM/dd")
                              .format(invoice.dateTime)),
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
      )),
    );
  }
}
