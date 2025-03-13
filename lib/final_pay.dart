import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cravy/token.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cart_provider.dart';

class FinalPay extends ConsumerStatefulWidget {
  final String userId;
  final int totalPrice;
  final String selectedSlot;
  final List<Map<String, dynamic>> cartItems;
  final int slotNumber;

  const FinalPay({
    super.key,
    required this.userId,
    required this.totalPrice,
    required this.selectedSlot,
    required this.cartItems,
    required this.slotNumber,
  });

  @override
  ConsumerState<FinalPay> createState() => _FinalPayState();
}

class _FinalPayState extends ConsumerState<FinalPay> {
  bool _isProcessing = false;

  Future<void> _processPayment() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      // Check slot availability before confirming order
      final slotRef = FirebaseFirestore.instance
          .collection('slots')
          .doc(widget.slotNumber.toString());
      final slotData = await slotRef.get();

      int currentCount = slotData.exists ? (slotData.data()?['count'] ?? 0) as int : 0;
      int slotLimit = _getSlotLimit(widget.slotNumber);

      print("Checking Slot: ${widget.slotNumber}, Current Count: $currentCount, Limit: $slotLimit");

      if (slotLimit == -1 || currentCount < slotLimit) {
        // Store order and capture reference
        DocumentReference orderRef = await FirebaseFirestore.instance.collection('orders').add({
          "userId": widget.userId,
          "items": widget.cartItems,
          "totalPrice": widget.totalPrice,
          "slot": widget.selectedSlot,
          "timestamp": Timestamp.now(),
          "paymentStatus": "Paid",
        });

        int? tokenNumber = await TokenManager.generateToken(
          orderRef.id,
          widget.userId,
          ref,
        );

        if (slotLimit != -1) {
          await slotRef.set({'count': currentCount + 1}, SetOptions(merge: true));
        }

        Future<void> saveTokenLocally(int tokenNumber) async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setInt('dailyToken', tokenNumber);
        }

        if (tokenNumber != null) {
          await saveTokenLocally(tokenNumber);
        }

        ref.read(cartProvider(widget.userId).notifier).clearCart();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                OrderConfirmationScreen(orderId: orderRef.id, tokenNumber: tokenNumber),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Slot ${widget.selectedSlot} is full. Please select another.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  // Get slot limits based on slot number
  int _getSlotLimit(int slotNumber) {
    const slotLimits = {1: 50, 2: 45, 3: 60, 4: -1}; // Slot 4 has no limit (-1)
    return slotLimits[slotNumber] ?? -1; // Default to unlimited if undefined
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Final Payment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Price: ₹${widget.totalPrice}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Selected Slot: ${widget.selectedSlot}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _isProcessing ? null : _processPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[600],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                ),
                child:
                _isProcessing
                    ? const CircularProgressIndicator()
                    : const Text('Pay Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderConfirmationScreen extends StatelessWidget {
  final String orderId;
  final int? tokenNumber;

  const OrderConfirmationScreen({
    super.key,
    required this.orderId,
    required this.tokenNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Confirmed')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Your order has been placed successfully!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Order ID: $orderId', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text(
              tokenNumber != null
                  ? 'Your Token: $tokenNumber'
                  : 'No token assigned',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
