import 'package:currency_textfield/currency_textfield.dart';
import 'package:flutter/material.dart';
import 'package:software_testing_project_pfms/widgets/app_button.dart';

import '../widgets/app_text_field.dart';

class ChargeDialog extends StatefulWidget {
  const ChargeDialog({super.key});

  @override
  State<ChargeDialog> createState() => _ChargeDialogState();

  static Future<int?> show(BuildContext context) {
    return showGeneralDialog<int?>(
      context: context,
      barrierDismissible: true,
      barrierLabel: "",
      pageBuilder: (context, animation, secondaryAnimation) {
        return const ChargeDialog();
      },
    );
  }
}

class _ChargeDialogState extends State<ChargeDialog> {
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
              onPressed: onSavePressed,
              color: _cAmount.intValue > 0 ? Colors.amber : Colors.blueGrey,
            ),
          ],
        ),
      ),
    );
  }

  void onSavePressed() {
    int intValue = _cAmount.intValue;
    if (intValue <= 0) {
      return;
    }
    if (negative) {
      intValue *= -1;
    }
    Navigator.of(context).pop(
      intValue,
    );
  }
}
