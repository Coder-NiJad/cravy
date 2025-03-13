import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'final_pay.dart';
import 'cart_provider.dart';

class Slot extends ConsumerStatefulWidget {
  final double totalPrice;
  final List<CartItem> items;
  const Slot({super.key, required this.items, required this.totalPrice});

  @override
  ConsumerState<Slot> createState() => _SlotState();
}

class _SlotState extends ConsumerState<Slot> {
  int? _selectedOption;
  Map<int, int> slotCounts = {};

  final Map<int, int> slotLimits = {
    1: 50,
    2: 45,
    3: 60,
    4: -1, // No limit for slot 4
  };

  final Map<int, String> slotTimes = { // CHANGED: Moved slot times to class-level
    1: '13:00 - 13:10',
    2: '13:10 - 13:20',
    3: '13:20 - 13:30',
    4: '13:30 - 13:50'
  };

  @override
  void initState() {
    super.initState();
    _fetchSlotAvailability();
  }

  Future<void> _fetchSlotAvailability() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('slots').get();
      final counts = {
        for (var doc in snapshot.docs)
          int.tryParse(doc.id) ?? 0: (doc.data()?['count'] as int?) ?? 0
      };


      debugPrint("Slot Data from Firestore: $counts");
      setState(() {
        slotCounts = counts;
      });
    } catch (e) {
      debugPrint("Error fetching slots: $e");
    }
  }

  Future<void> _selectSlot() async {
    if (_selectedOption == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a slot before proceeding.')),
      );
      return;
    }

    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final totalPrice = widget.totalPrice.toInt();
    final cartItems = widget.items;

    final List<Map<String, dynamic>> cartItemsMapped =
    cartItems.map((item) => item.toMap()).toList();

    // Get selected slot time
    final selectedSlot = slotTimes[_selectedOption] ?? '';

    // Navigate to payment screen WITHOUT updating slot count yet
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => FinalPay(
          userId: userId,
          totalPrice: totalPrice,
          selectedSlot: selectedSlot,
          cartItems: cartItemsMapped,
          slotNumber: _selectedOption!, // Pass the selected slot to update later
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Slot')),
      body: slotCounts.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: List.generate(4, (index) {
            int slotNumber = index + 1;
            bool isFull = slotLimits[slotNumber]! != -1 &&
                (slotCounts[slotNumber] ?? 0) >= slotLimits[slotNumber]!;

            return RadioListTile<int>(
              title: Text('Slot $slotNumber'),
              subtitle: Text(slotTimes[slotNumber] ?? ''),
              value: slotNumber,
              groupValue: _selectedOption,
              onChanged: isFull
                  ? null
                  : (value) {
                setState(() {
                  _selectedOption = value;
                });
              },
              activeColor: Colors.red[600],
              secondary: isFull ? const Text('Full', style: TextStyle(color: Colors.red)) : null,
            );
          }),
        ),
      ),
      floatingActionButton: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: FloatingActionButton(
          onPressed: _selectSlot,
          backgroundColor: Colors.red[600],
          child: const Text('Checkout', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}