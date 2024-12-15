import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsetsDirectional.only(
            start: 24,
            top: 80,
            end: 24,
            bottom: 40,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                CupertinoIcons.person_alt_circle,
                color: Colors.amber,
                size: 120,
              ),
              const SizedBox(
                height: 40,
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.black12,
                ),
                child: const Column(
                  children: [
                    TextField(),
                    Divider(
                      color: Colors.white,
                    ),
                    TextField(),
                  ],
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
