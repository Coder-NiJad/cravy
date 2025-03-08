import 'package:cravy/slot.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Example cart data
  List<Map<String, dynamic>> cartItems = [
    {
      'name': 'Pizza',
      'price': 200,
      'image': 'assets/images/Pizza.jpg',
      'quantity': 1,
    },
    {
      'name': 'Burger',
      'price': 150,
      'image': 'assets/images/burger.jpg',
      'quantity': 2,
    },
    {
      'name': 'Pasta',
      'price': 180,
      'image': 'assets/images/pasta.jpg',
      'quantity': 1,
    },
  ];

  // Calculate the total price
  double get totalPrice {
    return cartItems.fold(
      0,
          (sum, item) => sum + (item['price'] * item['quantity']),
    );
  }

  // Remove an item from the cart
  void removeItem(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
  }

  // Increase the quantity of an item
  void increaseQuantity(int index) {
    setState(() {
      cartItems[index]['quantity']++;
    });
  }

  // Decrease the quantity of an item
  void decreaseQuantity(int index) {
    setState(() {
      if (cartItems[index]['quantity'] > 1) {
        cartItems[index]['quantity']--;
      } else {
        removeItem(index); // Remove item if quantity is 0
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // List of cart items
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Container(
                  margin:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  height: 140, // Height of the box
                  child: Row(
                    children: [
                      // Item image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          item['image'],
                          width: MediaQuery.of(context).size.width * 0.25,
                          height: MediaQuery.of(context).size.height * 0.1,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Item details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment
                              .spaceBetween, // Ensure no overflow
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Item name
                                Text(
                                  item['name'],
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                // Delete icon
                                IconButton(
                                  onPressed: () => removeItem(index),
                                  icon: Icon(Icons.delete,
                                      color: Colors.red[600]),
                                ),
                              ],
                            ),
                            // Item price
                            Text(
                              'Price: ₹${item['price']}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '₹${(item['price'] * item['quantity']).toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                // Quantity controls
                                Container(
                                  height: 28,
                                  width: 112,
                                  //color: Colors.green,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: Colors.green[400]?.withOpacity(0.25),
                                      border: Border.all(color: Colors.lightGreen)
                                    //backgroundBlendMode: BlendMode.overlay
                                  ),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        onPressed: () => decreaseQuantity(index),
                                        icon: const Icon(Icons.remove),
                                        iconSize: 14,
                                        padding: const EdgeInsets.symmetric(horizontal: 1.0),
                                      ),
                                      Text(
                                        item['quantity'].toString(),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      IconButton(
                                        onPressed: () => increaseQuantity(index),
                                        icon: const Icon(Icons.add),
                                        iconSize: 14,
                                        padding: const EdgeInsets.symmetric(horizontal: 1.0),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Bottom section for total price and buy button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Card(
                    color: Colors.white,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.08,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Icon(Icons.request_page_outlined),
                                const Text(' Total Bill: ', style: TextStyle(fontSize: 16),),
                                Text(
                                  '₹${totalPrice.toStringAsFixed(2)}', // total final no. of items Rs . total price
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('        Inclusive of all taxes', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to payment options
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Slot(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[600],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Proceed to Checkout',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Placeholder for the PaymentScreen
// class PaymentScreen extends StatelessWidget {
//   const PaymentScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Payment Options'),
//         backgroundColor: Colors.red[600],
//       ),
//       body: const Center(
//         child: Text(
//           'Payment options will be implemented here.',
//           style: TextStyle(fontSize: 18),
//         ),
//       ),
//     );
//   }
// }
