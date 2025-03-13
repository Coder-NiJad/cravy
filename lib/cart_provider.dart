import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


// Cart Item Model
class CartItem {
  final String id;
  final String name;
  final double price;
  final int quantity;
  final String imageUrl;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });

  // Convert to Map (for Firebase)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
    };
  }

  // Convert from Firebase Map
  factory CartItem.fromMap(Map<String, dynamic> data) {
    return CartItem(
      id: data['id'],
      name: data['name'],
      price: data['price'].toDouble(),
      quantity: data['quantity'],
      imageUrl: data['imageUrl'],
    );
  }
}

// Cart Provider
class CartNotifier extends StateNotifier<List<CartItem>> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId; // User ID for Firebase storage

  CartNotifier(this.userId) : super([]) {
    _loadCartFromFirebase();
  }

  // Load cart data from Firestore
  Future<void> _loadCartFromFirebase() async {
    final cartSnapshot =
    await _firestore.collection('carts').doc(userId).collection('items').get();

    state = cartSnapshot.docs
        .map((doc) => CartItem.fromMap(doc.data()))
        .toList();
  }

  // Add Item to Cart
  void addToCart(CartItem item) {
    final existingIndex = state.indexWhere((cartItem) => cartItem.id == item.id);
    if (existingIndex >= 0) {
      state[existingIndex] = CartItem(
        id: item.id,
        name: item.name,
        price: item.price,
        quantity: state[existingIndex].quantity + 1,
        imageUrl: item.imageUrl,
      );
    } else {
      state = [...state, item];
    }
    _updateFirebaseCart();
  }

  // Remove Item from Cart
  void removeFromCart(String id) {
    state = state.where((item) => item.id != id).toList();
    _updateFirebaseCart();
  }

  // Clear Cart
  void clearCart() {
    state = [];
    _firestore.collection('carts').doc(userId).delete();
  }
  // Increase quantity of a cart item
  void increaseQuantity(String id) {
    final index = state.indexWhere((item) => item.id == id);
    if (index != -1) {
      state = [
        ...state.sublist(0, index),
        CartItem(
          id: state[index].id,
          name: state[index].name,
          price: state[index].price,
          quantity: state[index].quantity + 1, // Increase quantity
          imageUrl: state[index].imageUrl,
        ),
        ...state.sublist(index + 1),
      ];
      _updateFirebaseCart();
    }
  }

// Decrease quantity of a cart item
  void decreaseQuantity(String id) {
    final index = state.indexWhere((item) => item.id == id);
    if (index != -1) {
      if (state[index].quantity > 1) {
        state = [
          ...state.sublist(0, index),
          CartItem(
            id: state[index].id,
            name: state[index].name,
            price: state[index].price,
            quantity: state[index].quantity - 1, // Decrease quantity
            imageUrl: state[index].imageUrl,
          ),
          ...state.sublist(index + 1),
        ];
      } else {
        // Remove item if quantity reaches 0
        removeFromCart(id);
      }
      _updateFirebaseCart();
    }
  }


  // Update Firestore Cart
  Future<void> _updateFirebaseCart() async {
    final cartRef = _firestore.collection('carts').doc(userId).collection('items');
    await cartRef.get().then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
    for (var item in state) {
      await cartRef.doc(item.id).set(item.toMap());
    }
  }
  // Add this method inside CartNotifier
  Future<void> checkout() async {
    if (state.isEmpty) return;

    final orderId = _firestore.collection('orders').doc().id; // Generate Order ID
    final orderData = {
      'orderId': orderId,
      'userId': userId,
      'items': state.map((item) => item.toMap()).toList(),
      'totalPrice': state.fold<double>(0, (total, item) => total + (item.price * item.quantity)),
      'timestamp': FieldValue.serverTimestamp(),
    };

    await _firestore.collection('orders').doc(orderId).set(orderData);

    // Clear Cart (Both Local & Firestore)
    clearCart();
  }

}

// Riverpod Provider
final cartProvider = StateNotifierProvider.family<CartNotifier, List<CartItem>, String>((ref, userId) {
  return CartNotifier(userId);
});
