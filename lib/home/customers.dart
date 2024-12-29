import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:software_testing_project_pfms/db/app_database.dart';
import 'package:software_testing_project_pfms/models/customer.dart';

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
        child: Icon(Icons.add),
        onPressed: () {},
      ),
      body: SafeArea(
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
                        leading: const Icon(Icons.person_outlined),
                        title: Text(customer.name),
                        subtitle: Text(
                          customer.balance.toString(),
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
      )),
    );
  }
}
