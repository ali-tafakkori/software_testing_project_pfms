import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:photo_view/photo_view.dart';
import 'package:software_testing_project_pfms/db/app_database.dart';
import 'package:software_testing_project_pfms/image_manager.dart';
import 'package:software_testing_project_pfms/models/invoice.dart';

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
  Invoice? invoice;

  @override
  void initState() {
    get();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (invoice != null) {
      var child;
      if (invoice!.image != null) {
        child = PhotoView(
          imageProvider: FileImage(
            File(
              ImageManager.instance.photosDirectoryPath + invoice!.image!,
            ),
          ),
        );
      } else {
        child = const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.image_not_supported_outlined,
              size: 80,
              color: Colors.black45,
            ),
            Text(
              "No Photo",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
                color: Colors.black45,
              ),
            ),
          ],
        );
      }
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: ListTile(
            subtitle: Text(DateFormat("yyyy/MM/dd").format(invoice!.dateTime)),
            title: Text(
              NumberFormat.simpleCurrency(decimalDigits: 0)
                  .format(invoice!.amount),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                ImageManager.instance.showDialogImagePicker(
                  context: context,
                  onDelete: invoice!.image != null ? () {
                    //TODO:
                    get();
                  } : null,
                );
              },
              icon: const Icon(
                Icons.image_outlined,
              ),
            ),
          ],
        ),
        body: child,
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: Center(
        child: LoadingAnimationWidget.inkDrop(
          color: Colors.amber,
          size: 48,
        ),
      ),
    );
  }

  void get() async {
    setState(() {});
    invoice = await AppDatabase.instance.invoiceDao.findById(
      widget.id,
    );
    setState(() {});
  }
}
