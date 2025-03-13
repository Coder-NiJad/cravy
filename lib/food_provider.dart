import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// 🔹 Search Query Provider
final searchQueryProvider = StateProvider<String>((ref) => '');

// 🔹 Food Provider with Search Support
final foodProvider = StateNotifierProvider<FoodNotifier, AsyncValue<List<Map<String, dynamic>>>>(
      (ref) => FoodNotifier(ref),
);

class FoodNotifier extends StateNotifier<AsyncValue<List<Map<String, dynamic>>>> {
  final Ref ref;
  List<Map<String, dynamic>> _allItems = []; // Store all items

  FoodNotifier(this.ref) : super(const AsyncValue.loading()) {
    fetchAllFoodItems();
    ref.listen<String>(searchQueryProvider, (_, __) => filterFoodItems());
  }

  // Fetch all food items from Firestore
  Future<void> fetchAllFoodItems() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final menuCollection = firestore.collection('menu');

      final menuCategories = await menuCollection.get();
      List<Map<String, dynamic>> allItems = [];

      for (var category in menuCategories.docs) {
        final itemsCollection = menuCollection.doc(category.id).collection('items');
        final itemsSnapshot = await itemsCollection.get();

        for (var itemDoc in itemsSnapshot.docs) {
          final itemData = itemDoc.data();
          itemData['category'] = category.id; // Store category for reference
          allItems.add(itemData);
        }
      }

      _allItems = allItems; // Store all items for filtering
      filterFoodItems(); // Apply filtering after fetching

    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  // 🔍 Filter items based on search query
  void filterFoodItems() {
    final query = ref.read(searchQueryProvider).toLowerCase();

    if (query.isEmpty) {
      // Show only 16 random items if no search query
      _allItems.shuffle();
      state = AsyncValue.data(_allItems.take(16).toList());
    } else {
      // Show all items matching the search
      final filteredItems = _allItems.where((food) {
        final name = (food['Name'] as String).toLowerCase();
        return name.contains(query);
      }).toList();

      state = AsyncValue.data(filteredItems);
    }
  }
}
