import 'dart:async';

import 'package:cravy/home_screen.dart';
import 'package:flutter/material.dart';

class token extends StatefulWidget {
  const token({super.key});

  @override
  State<token> createState() => _tokenState();
}

class _tokenState extends State<token> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Your Token Number is', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),),
              Text(
                '13',
                style: TextStyle(fontSize: 72, color: Colors.red[600]),
              ),
              const Text('Show this at the counter', style: TextStyle(fontSize: 20),),
            ],
          ),
        ),
      ),
    );
  }
}
