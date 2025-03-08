import 'dart:async';

import 'package:cravy/token.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PaySuccess extends StatefulWidget {
  const PaySuccess({super.key});

  @override
  State<PaySuccess> createState() => _PaySuccessState();
}

class _PaySuccessState extends State<PaySuccess> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), (){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const token()));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12.0, 8.0, 8.0, 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(
                child: Text(
                  'Payment Successful !',
                  style: TextStyle(fontSize: 34),
                )),
            Lottie.asset('assets/success_tick.json',
                width: 150, height: 150, repeat: false),
          ],
        ),
      ),
    );
  }
}
