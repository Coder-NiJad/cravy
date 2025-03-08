import 'package:flutter/material.dart';

import 'final_pay.dart';

class Slot extends StatefulWidget {
  const Slot({super.key});

  @override
  State<Slot> createState() => _SlotState();
}

class _SlotState extends State<Slot> {
  int _selectedOption = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Slot'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 350.0),
        child: Card(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              // Option 1
              RadioListTile<int>(
                title: const Text('Slot 1'),
                subtitle: const Text('1:00PM - 1:10PM'),
                activeColor: Colors.red[600],
                value: 1,
                groupValue: _selectedOption,
                onChanged: (value) {
                  setState(() {
                    _selectedOption = value!;
                  });
                },
              ),
              // Option 2
              RadioListTile<int>(
                title: const Text('Slot 2'),
                subtitle: const Text('1:10PM - 1:20PM'),
                activeColor: Colors.red[600],
                value: 2,
                groupValue: _selectedOption,
                onChanged: (value) {
                  setState(() {
                    _selectedOption = value!;
                  });
                },
              ),
              // Option 3
              RadioListTile<int>(
                title: const Text('Slot 3'),
                subtitle: const Text('1:20PM - 1:35PM'),
                activeColor: Colors.red[600],
                value: 3,
                groupValue: _selectedOption,
                onChanged: (value) {
                  setState(() {
                    _selectedOption = value!;
                  });
                },
              ),
              // Option 4
              RadioListTile<int>(
                title: const Text('Slot 4'),
                subtitle: const Text('1:35PM - 1:50PM'),
                activeColor: Colors.red[600],
                value: 4,
                groupValue: _selectedOption,
                onChanged: (value) {
                  setState(() {
                    _selectedOption = value!;
                  });
                },
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: FloatingActionButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Selected Slot: $_selectedOption',
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w500),
                          ),
                          backgroundColor: Colors.lightGreen,
                        ),
                      );
                      Future.delayed(const Duration(seconds: 2), () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const finalPay()));
                      });
                    },
                    backgroundColor: Colors.red[600],
                    foregroundColor: Colors.white,
                    child: const Text(
                      'Checkout',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
