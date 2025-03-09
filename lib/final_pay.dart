import 'dart:async';

import 'package:cravy/payment_screen.dart';
import 'package:flutter/material.dart';

class finalPay extends StatefulWidget {
  const finalPay({super.key});

  @override
  State<finalPay> createState() => _finalPayState();
}

class _finalPayState extends State<finalPay> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 15), (){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const PaySuccess()));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Redirecting to your payment app', style: TextStyle(fontSize: 20),),
                const SizedBox(height: 15,),
                CircularProgressIndicator(
                  color: Colors.red[600], //run for 15 sec
                ),
                const SizedBox(height: 15,),
                const Text('Do not close this window!', style: TextStyle(fontSize: 16),),
              ],
            ),
          )),
    );
  }
}
