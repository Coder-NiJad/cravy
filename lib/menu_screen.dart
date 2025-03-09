// menu_screen.dart
import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[600],
        title: const Text('Menu'),
      ),
      body: ListView(
        children: [
          // Beverages Category
          buildCategory(
            'Beverages',
            [
              menuItem('Chai', '10/-'),
              menuItem('Coffee', '20/-'),
              menuItem('Black Coffee', '15/-'),
              menuItem('Lassi', '30/-'),
              menuItem('Butter Milk', '20/-'),
              menuItem('Cold Coffee', '50/-'),
              menuItem('Chocolate Shake', '50/-'),
              menuItem('Strawberry Shake', '50/-'),
            ],
          ),

          // Snacks Category
          buildCategory(
            'Snacks',
            [
              menuItem('Poha', '15/-'),
              menuItem('Kachori', '15/-'),
              menuItem('Aloo Bada', '15/-'),
              menuItem('Bread Bada', '20/-'),
              menuItem('Baked Samosa (Sada)', '20/-'),
              menuItem('Baked Samosa (Banakar)', '25/-'),
              menuItem('Peanut Chaat', '35/-'),
              menuItem('Sabudana Khichdi', '30/-'),
              menuItem('Dal Pakwan', '35/-'),
              menuItem('Chatpati Bhel', '35/-'),
            ],
          ),

          // Sandwiches Category
          buildCategory(
            'Sandwiches',
            [
              menuItem('Veg Sandwich', '40/-'),
              menuItem('Masala Sandwich', '40/-'),
              menuItem('Tandoori Masala Sandwich', '50/-'),
              menuItem('Cheese Sandwich', '60/-'),
              menuItem('Double Cheese Sandwich', '75/-'),
              menuItem('Cheese Chatni Sandwich', '75/-'),
            ],
          ),

          // Maggi & Noodles Category
          buildCategory(
            'Maggi & Noodles',
            [
              menuItem('Plain Maggi', '30/-'),
              menuItem('Vegetable Maggi', '35/-'),
              menuItem('Cheese Plain Maggi', '55/-'),
              menuItem('Veg Cheese Maggi', '60/-'),
              menuItem('Veg Noodles', '50/-'),
              menuItem('Noodles with Manchurian', '60/-'),
              menuItem('Veg Manchurian Gravy', '60/-'),
              menuItem('Veg Manchurian Dry', '70/-'),
            ],
          ),

          // Rice & Fried Dishes Category
          buildCategory(
            'Rice & Fried Dishes',
            [
              menuItem('Fried Rice', '50/-'),
              menuItem('Fried Rice with Manchurian', '60/-'),
            ],
          ),

          // Thali & Combo Meals Category
          buildCategory(
            'Thali & Combo Meals',
            [
              menuItem('Bhojan Thali Mini', '45/-'),
              menuItem('Bhojan Thali Full', '65/-'),
              menuItem('Dal Chawal Mix', '35/-'),
            ],
          ),

          // Dosa & South Indian Category
          buildCategory(
            'Dosa & South Indian',
            [
              menuItem('Masala Dosa', '60/-'),
              menuItem('Paneer Dosa', '80/-'),
              menuItem('Onion Tomato Utapam', '65/-'),
              menuItem('Idli Sambhar', '50/-'),
            ],
          ),

          // Parathas Category
          buildCategory(
            'Parathas',
            [
              menuItem('Aloo Paratha with Dahi', '35/-'),
              menuItem('Sev Paratha', '45/-'),
              menuItem('Paneer Paratha', '50/-'),
              menuItem('Sada Paratha', '18/-'),
            ],
          ),

          // Chinese Category
          buildCategory(
            'Chinese',
            [
              menuItem('Chilli Paneer Gravy', '85/-'),
              menuItem('Chilli Paneer Dry', '100/-'),
            ],
          ),

          // Indian Main Course Category
          buildCategory(
            'Indian Main Course',
            [
              menuItem('Sev Tamatar', '50/-'),
              menuItem('Dal Fry', '50/-'),
              menuItem('Butter Paneer Masala', '80/-'),
              menuItem('Kadai Paneer', '80/-'),
              menuItem('Shahi Paneer', '85/-'),
              menuItem('Jeera Aloo', '50/-'),
              menuItem('Aloo Chatpata', '50/-'),
              menuItem('Jeera Rice', '40/-'),
              menuItem('Plain Rice', '30/-'),
              menuItem('Butter Khichdi', '75/-'),
              menuItem('Pav Bhaji', '55/-'),
              menuItem('Extra Pav', '15/-'),
            ],
          ),
        ],
      ),
    );
  }

  // Helper method to build menu category with items
  Widget buildCategory(String categoryName, List<Widget> items) {
    return ExpansionTile(
      title: Text(
        categoryName,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      children: items,
    );
  }

  // Helper method to build menu item
  Widget menuItem(String itemName, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            itemName,
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            price,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
