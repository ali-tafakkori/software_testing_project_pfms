import 'package:flutter/material.dart';

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
      appBar: AppBar(),
    );
  }
}
