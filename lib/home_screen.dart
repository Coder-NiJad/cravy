// home_screen.dart

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cravy/popular_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'food_provider.dart';
import 'menu_screen.dart';
import 'cart_screen.dart';
import 'cart_provider.dart';

// Import MenuScreen

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0; // Track the current index of the BottomNavigationBar

  final List<Widget> _screens = [
    const HomeContent(), // Home screen content
    const CartScreen(), // Cart screen
    MenuScreen(userId: userId), // Menu screen
    Container(), // Placeholder for Favorites
    Container(), // Placeholder for Profile
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: _screens[_currentIndex],
          backgroundColor: Colors.white,
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.red[600],
            selectedItemColor: Colors.red[600],
            unselectedItemColor: Colors.grey,
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                label: 'Cart',
              ),
              BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Menu'),
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
        ),
        TokenOverlay(),
      ],
    );
  }
}

class HomeContent extends ConsumerWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;
    String userName = "User";
    final foodState = ref.watch(foodProvider);
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'guest';

    if (user != null) {
      if (user.displayName != null && user.displayName!.isNotEmpty) {
        userName = user.displayName!;
      } else if (user.email != null) {
        userName = user.email!.split('@')[0]; // Extracts part before '@'
        userName = userName.replaceAll(
          RegExp(r'[^a-zA-Z]'),
          '',
        ); // Remove numbers & punctuation
        if (userName.isEmpty)
          userName = "User"; // Fallback in case of empty result
      }
    }

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.2,
            color: Colors.red[600],
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.03,
                vertical: MediaQuery.of(context).size.height * 0.0001,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: Container()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Hey $userName!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width * 0.05,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.01,
                          vertical: MediaQuery.of(context).size.height * 0.005,
                        ),
                        child: CircleAvatar(
                          radius: MediaQuery.of(context).size.width * 0.06,
                          backgroundImage: const AssetImage(
                            'assets/images/cravybglogo.png',
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(child: Container()),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.08,
                    child: TextField(
                      onChanged:
                          (value) =>
                              ref.read(searchQueryProvider.notifier).state =
                                  value,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
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

          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.015,
              vertical: MediaQuery.of(context).size.height * 0.015,
            ),
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

          SizedBox(
            height: MediaQuery.of(context).size.height * 0.23,
            child: Consumer(
              builder: (context, ref, child) {
                final popularItemsState = ref.watch(popularFoodProvider);

                return popularItemsState.when(
                  data:
                      (popularItems) => CarouselSlider(
                        options: CarouselOptions(
                          aspectRatio: 16 / 9,
                          height: MediaQuery.of(context).size.height * 0.3,
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 2),
                          enlargeCenterPage: true,
                          viewportFraction: 0.8,
                        ),
                        items:
                            popularItems.map((item) {
                              return foodCard(
                                item['id'],
                                item['imageUrl'],
                                item['Name'],
                                item['Price']
                                    .toDouble(), // Ensure price is a double
                                ref,
                                context,
                              );
                            }).toList(),
                      ),
                  loading:
                      () => const Center(child: CircularProgressIndicator()),
                  error:
                      (error, stackTrace) =>
                          Center(child: Text('Error: $error')),
                );
              },
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.015,
              vertical: MediaQuery.of(context).size.height * 0.015,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'EXPLORE MORE',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.045,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          foodState.when(
            loading:
                () =>
                    Center(child: CircularProgressIndicator()), // Loading State
            error:
                (error, _) =>
                    Center(child: Text('Error: $error')), // Error State
            data: (foodItems) {
              final searchQuery = ref.watch(
                searchQueryProvider,
              ); // ✅ Fetch search query

              // 🔍 Apply search filter
              final filteredItems =
                  foodItems.where((food) {
                    final name = (food['Name'] as String?)?.toLowerCase() ?? '';
                    return name.contains(searchQuery.toLowerCase());
                  }).toList();

              // 🔢 Limit to 16 items only if there's no search query
              final displayedItems =
                  searchQuery.isEmpty
                      ? filteredItems.take(16).toList()
                      : filteredItems; // Show all search results

              return GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.all(8),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.75, // Adjust height/width ratio
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: displayedItems.length,
                itemBuilder: (context, index) {
                  final food = displayedItems[index];
                  final foodId = food['id']; // Ensure each food item has an ID
                  final foodName = food['Name'] ?? 'Unknown';
                  final foodPrice = food['Price']?.toDouble() ?? 0.0;
                  final foodImage = food['imageUrl'] ?? 'n/a';

                  return GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Consumer(
                            builder: (context, ref, child) {
                              return Container(
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        Image.network(
                                          foodImage,
                                          height: 100,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Icon(
                                                    Icons.image_not_supported,
                                                  ),
                                        ),
                                        const SizedBox(width: 15),
                                        Text(
                                          '$foodName - ₹$foodPrice',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 30),
                                        Container(
                                          //width: MediaQuery.of(context).size.width * 0.15,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              5.0,
                                            ),
                                            color: Colors.green.shade400
                                                .withValues(
                                                  alpha: (0.25 * 255),
                                                ),
                                            border: Border.all(
                                              color: Colors.lightGreen,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              IconButton(
                                                icon: Icon(Icons.add_outlined),
                                                //iconSize: MediaQuery.of(context).size.width * 0.05,
                                                onPressed: () {
                                                  ref
                                                      .read(
                                                        cartProvider(
                                                          userId,
                                                        ).notifier,
                                                      )
                                                      .addToCart(
                                                        CartItem(
                                                          id: foodId,
                                                          name: foodName,
                                                          price: foodPrice,
                                                          quantity: 1,
                                                          // Default quantity
                                                          imageUrl: foodImage,
                                                        ),
                                                      );
                                                },
                                              ),
                                              IconButton(
                                                icon: Icon(
                                                  Icons.remove_outlined,
                                                ),
                                                //iconSize: MediaQuery.of(context).size.width * 0.05,
                                                onPressed: () {
                                                  ref
                                                      .read(
                                                        cartProvider(
                                                          userId,
                                                        ).notifier,
                                                      )
                                                      .removeFromCart(foodName);
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                    child: Card(
                      elevation: 4,
                      child: Column(
                        children: [
                          Expanded(
                            child: Image.network(
                              foodImage,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) =>
                                      Icon(Icons.image_not_supported),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              foodName,
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Text('₹$foodPrice'),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

final user = FirebaseAuth.instance.currentUser;
final userId = user?.uid ?? "guest";

Widget foodCard(
  String id,
  String imagePath,
  String name,
  double price,
  WidgetRef ref,
  BuildContext context,
) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 4,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          foodItem(id, imagePath, name, price, ref, context),
          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Text('₹$price', textAlign: TextAlign.center),
        ],
      ),
    ),
  );
}

Widget foodItem(
  String id,
  String imageUrl,
  String name,
  double price,
  WidgetRef ref,
  BuildContext context,
) {
  return GestureDetector(
    onTap: () {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Consumer(
            builder: (context, ref, child) {
              return Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Image.network(
                          imageUrl,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) =>
                                  Icon(Icons.image_not_supported),
                        ),
                        const SizedBox(width: 15),
                        Text(
                          '$name - ₹$price',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 30),
                        Container(
                          //width: MediaQuery.of(context).size.width * 0.15,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: Colors.green.shade400.withValues(
                              alpha: (0.25 * 255),
                            ),
                            border: Border.all(color: Colors.lightGreen),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(Icons.add),
                                // iconSize:
                                //     MediaQuery.of(context).size.width * 0.03,
                                onPressed: () {
                                  ref
                                      .read(cartProvider(userId).notifier)
                                      .addToCart(
                                        CartItem(
                                          id: id, // You might need a unique ID instead of name
                                          name: name,
                                          price: price,
                                          quantity:
                                              1, // Assuming quantity starts at 1
                                          imageUrl: imageUrl,
                                        ),
                                      );
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.remove),
                                // iconSize:
                                //     MediaQuery.of(context).size.width * 0.03,
                                onPressed: () {
                                  ref
                                      .read(cartProvider(userId).notifier)
                                      .removeFromCart(name);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    },
    child: Image.asset(
      imageUrl,
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.14,
      fit: BoxFit.cover,
    ),
  );
}

class TokenOverlay extends ConsumerStatefulWidget {
  const TokenOverlay({super.key});

  @override
  ConsumerState<TokenOverlay> createState() => _TokenOverlayState();
}

class _TokenOverlayState extends ConsumerState<TokenOverlay> {
  Future<int?> fetchLatestToken(String userId) async {
    var snapshot =
        await FirebaseFirestore.instance.collection('tokens').doc(userId).get();

    if (snapshot.exists && snapshot.data()?['tokenNumber'] != null) {
      return snapshot.data()!['tokenNumber'];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const SizedBox();

    return FutureBuilder<int?>(
      future: fetchLatestToken(user.uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return const SizedBox(); // Hide if no token
        }

        final token = snapshot.data!;

        return Positioned(
          bottom: 60,
          right: 20,
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            child: Icon(Icons.token, color: Colors.black),
            onPressed: () {
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text("Your Latest Token"),
                      content: Text("Token Number: $token"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("OK"),
                        ),
                      ],
                    ),
              );
            },
          ),
        );
      },
    );
  }
}
