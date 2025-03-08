// home_screen.dart

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'menu_screen.dart';
import 'cart_screen.dart';
// Import MenuScreen

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0; // Track the current index of the BottomNavigationBar

  final List<Widget> _screens = [
    const HomeContent(), // Home screen content
    const CartScreen(), // Cart screen
    const MenuScreen(), // Menu screen
    Container(), // Placeholder for Favorites
    Container(), // Placeholder for Profile
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      backgroundColor:
      Colors.white, // Show the current screen based on the selected index
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.red[600], // Orange background for the nav bar
        selectedItemColor: Colors.red[600],
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex, // Set the current index
        onTap: (index) {
          // Update the current index to switch between screens
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Menu', // This will navigate to the MenuScreen
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// Separate the Home Content into its own StatelessWidget
class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Top Section (Orange Background)
            Container(
              height: MediaQuery.of(context).size.height *
                  0.2, // 1/5th of the screen
              color: Colors.red[600], // Orange background
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.03,
                  vertical: MediaQuery.of(context).size.height * 0.0001,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: Container()),
                    //SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    // Row with 'Hey Radhika' text and profile image
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Hey Nishit!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width * 0.05,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                              MediaQuery.of(context).size.width * 0.01,
                              vertical:
                              MediaQuery.of(context).size.height * 0.005),
                          child: CircleAvatar(
                            radius: MediaQuery.of(context).size.width * 0.06,
                            backgroundImage: const AssetImage(
                                'assets/images/cravybglogo.png'), // Placeholder image URL
                          ),
                        ),
                      ],
                    ),
                    // SizedBox(
                    //     height: MediaQuery.of(context).size.height * 0.008),
                    // Search bar
                    Expanded(child: Container()),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.08,
                      child: TextField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon:
                          const Icon(Icons.search, color: Colors.grey),
                          hintText: 'Search your favorite food...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Popular heading
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.99, vertical: MediaQuery.of(context).size.height) * 0.015,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'POPULAR CURRENTLY',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.045,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Horizontal Scroll for Food Items (Images 345x165)
            SizedBox(
              height: MediaQuery.of(context).size.height *
                  0.23, // Adjust height for the food item images
              child: CarouselSlider(
                options: CarouselOptions(
                  aspectRatio: 16 / 9,
                  height: MediaQuery.of(context).size.height * 0.25,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 2),
                  enlargeCenterPage: true,
                  viewportFraction: 0.8, // Similar to itemExtent
                ),
                items: [
                  foodItem('assets/images/Pizza.jpg', 'Pizza', context),
                  foodItem('assets/images/burger.jpg', 'Burger', context),
                  foodItem('assets/images/sushi.jpg', 'Sushi', context),
                  foodItem('assets/images/pasta.jpg', 'Pasta', context),
                ],
              ),
            ),

            // "What's on your mind?" text
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
              child: Center(
                child: Text(
                  "WHAT'S ON YOUR MIND?",
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.045,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            // Horizontal Scroll for Food Items (Images 90x90)
            SizedBox(
              height: MediaQuery.of(context).size.height *
                  0.16, // Adjust height for the smaller food item images
              child: CarouselSlider(
                options: CarouselOptions(
                  aspectRatio: 16 / 9,
                  // enableInfiniteScroll: false,
                  height: MediaQuery.of(context).size.height * 0.16,
                  autoPlay: false,
                  enlargeCenterPage: false,
                  viewportFraction: 0.6,
                ),
                items: [
                  smallFoodItem('assets/images/bakedsamosa.jpeg',
                      'Baked Samosa', context),
                  smallFoodItem('assets/images/cheesesandwich.jpg',
                      'Cheese Sandwich', context),
                  smallFoodItem('assets/images/dosa.jpg', 'Dosa', context),
                  smallFoodItem(
                      'assets/images/kachori.jpg', 'Kachori', context),
                  smallFoodItem('assets/images/lassi.jpeg', 'Lassi', context),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height *
                  0.16, // Adjust height for the smaller food item images
              child: CarouselSlider(
                options: CarouselOptions(
                  aspectRatio: 16 / 9,
                  height: MediaQuery.of(context).size.height * 0.16,
                  autoPlay: false,
                  enlargeCenterPage: false,
                  viewportFraction: 0.6,
                ),
                items: [
                  smallFoodItem('assets/images/samosa.jpg', 'Samosa', context),
                  smallFoodItem('assets/images/poha.jpg', 'Poha', context),
                  smallFoodItem('assets/images/dosa.jpg', 'Dosa', context),
                  smallFoodItem(
                      'assets/images/kachori.jpg', 'Kachori', context),
                  smallFoodItem('assets/images/lassi.jpeg', 'Lassi', context),
                  smallFoodItem(
                      'assets/images/DalPakwan.jpg', 'Dal Pakwan', context),
                  smallFoodItem('assets/images/jodhpuri.png',
                      'Jodhpuri Kachori', context),
                ],
              ),
            ),
          ],
        ));
  }

  // Widget to create a food item card for horizontal scrolling (large images)
  Widget foodItem(String imageUrl, String name, BuildContext context) {
    return Card(
      color: Colors.white,
      child: Column(
        children: [
          // Image.network(
          //   imageUrl,
          //   width: MediaQuery.of(context).size.width * 0.9,
          //   height: MediaQuery.of(context).size.height * 0.16,
          //   fit: BoxFit.cover,
          // ),
          Image.asset(imageUrl,
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.16,
              fit: BoxFit.cover),
          // SizedBox(
          //   height: MediaQuery.of(context).size.height * 0.01,
          //   width: MediaQuery.of(context).size.width * 0.15,
          // ),
          Text(
            name,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.05,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Widget to create smaller food item cards for horizontal scrolling
  Widget smallFoodItem(String imageUrl, String name, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          imageUrl,
          //width: 140,
          width: MediaQuery.of(context).size.width * 0.55,
          height: MediaQuery.of(context).size.height * 0.12,
          fit: BoxFit.cover,
        ),
        const SizedBox(height: 5),
        Text(
          name,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.03,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
