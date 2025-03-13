import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'cart_provider.dart'; // Import your cart provider

class MenuScreen extends ConsumerStatefulWidget {
  final String userId;

  const MenuScreen({super.key, required this.userId});

  @override
  ConsumerState<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<MenuScreen> {
  void _addToCart(Map<String, dynamic> itemData, String itemId) {
    final cartNotifier = ref.read(cartProvider(widget.userId).notifier);

    final cartItem = CartItem(
      id: itemId,
      name: itemData['Name'] ?? "Unknown Item",
      price: (itemData['Price']?.toDouble() ?? 0.0),
      quantity: 1,
      imageUrl: itemData['imageUrl'] ?? "https://via.placeholder.com/50", // Default image
    );

    cartNotifier.addToCart(cartItem);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Added to Cart")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Menu")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('menu').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No menu categories available"));
          }

          final categories = snapshot.data!.docs;
          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final categoryDoc = categories[index];
              return CategorySection(categoryDoc.id, _addToCart); // Pass method
            },
          );
        },
      ),
    );
  }
}


class CategorySection extends StatelessWidget {
  final String categoryName;
  final Function(Map<String, dynamic>, String) onAddToCart; // Pass callback

  const CategorySection(this.categoryName, this.onAddToCart, {super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('menu')
          .doc(categoryName)
          .collection('items')
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const SizedBox.shrink(); // Prevents layout errors
        }

        final items = snapshot.data!.docs;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                categoryName,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(), // Fix nested scrolling issue
              itemCount: items.length,
              itemBuilder: (context, index) {
                final itemData = items[index].data() as Map<String, dynamic>?;
                final itemId = items[index].id;

                if (itemData == null) return const SizedBox.shrink(); // Prevent errors

                return ListTile(
                  title: Text(itemData['Name'] ?? "Unnamed Item"),
                  subtitle: Text("\₹${(itemData['Price'] ?? 0).toString()}"),
                  leading: itemData['imageUrl'] != null
                      ? Image.network(
                    itemData['imageUrl'],
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                  )
                      : const Icon(Icons.fastfood),
                  trailing: IconButton(
                    icon: const Icon(Icons.add_shopping_cart),
                    onPressed: ()=> onAddToCart(itemData, itemId),

                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}