import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:software_testing_project_pfms/models/customer.dart';

class InvoiceDetails extends StatefulWidget {
  final int id;

  const InvoiceDetails({
    super.key,
    required this.id,
  });

  @override
  State<InvoiceDetails> createState() => _InvoiceDetailsState();
}

class _InvoiceDetailsState extends State<InvoiceDetails> {
  Customer? customer;

  @override
  Widget build(BuildContext context) {
    if (customer != null) {}
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: Center(
        child: LoadingAnimationWidget.newtonCradle(
          color: Colors.black,
          size: 53,
        ),
      ),
    );
  }
}
