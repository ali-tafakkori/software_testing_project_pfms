import 'package:currency_textfield/currency_textfield.dart';
import 'package:flutter/material.dart';
import 'package:ir_datetime_picker/ir_datetime_picker.dart';
import 'package:software_testing_project_pfms/models/charge.dart';
import 'package:software_testing_project_pfms/utils.dart';
import 'package:software_testing_project_pfms/widgets/app_button.dart';
import 'package:software_testing_project_pfms/widgets/app_text_field.dart';

class ChargeDialog extends StatefulWidget {
  final int customerId;

  const ChargeDialog({
    super.key,
    required this.customerId,
  });

  @override
  State<ChargeDialog> createState() => _ChargeDialogState();

  static Future<Charge?> show(BuildContext context, int customerId) {
    return showGeneralDialog<Charge?>(
      context: context,
      barrierDismissible: true,
      barrierLabel: "",
      pageBuilder: (context, animation, secondaryAnimation) {
        return ChargeDialog(
          customerId: customerId,
        );
      },
    );
  }
}

class _ChargeDialogState extends State<ChargeDialog> {
  DateTime dateTime = DateTime.now();
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

  bool negative = false;

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
                    controller: _atfcAmount,
                    inputType: TextInputType.number,
                    noBorder: true,
                    hintText: "مبلغ",
                    width: double.infinity,
                    prefixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          negative = !negative;
                        });
                      },
                      icon: Icon(
                        negative
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
              text: "شارژ",
              onPressed: onChargePressed,
              color: _cAmount.intValue > 0 ? Colors.amber : Colors.blueGrey,
            ),
          ],
        ),
      ),
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

  void onChargePressed() {
    int intValue = _cAmount.intValue;
    if (intValue <= 0) {
      setState(() {
        warning = "مبلغ الزامی است.";
      });
      return;
    }
    if (negative) {
      intValue *= -1;
    }
    Navigator.of(context).pop(
      Charge(
        customerId: widget.customerId,
        amount: intValue,
        dateTime: dateTime,
      ),
    );
  }
}
