
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:photo_view/photo_view.dart';
import 'package:software_testing_project_pfms/db/app_database.dart';
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
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: ListTile(
            subtitle: Text(DateFormat("yyyy/MM/dd")
                .format(invoice!.dateTime)),
            title: Text(
              NumberFormat.simpleCurrency(decimalDigits: 0)
                  .format(invoice!.amount),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        body: PhotoView(
          //TODO:
          imageProvider: NetworkImage(
              "https://design-assets.adobeprojectm.com/content/download/express/public/urn:aaid:sc:VA6C2:ca78dfb7-b478-548f-8f49-17a0d719f24c/component?assetType=TEMPLATE&etag=27cd1224f83b4f24bb56476616474b63&revision=215141d1-4747-4b2d-a8c1-dc7664031690&component_id=d640bea6-cfa0-4e68-950f-07fbd5942d3d"),
        ),
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
    invoice = await AppDatabase.instance.invoiceDao.findById(
      widget.id,
    );
    setState(() {

    });
  }
}
