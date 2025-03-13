import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final popularFoodProvider = StateNotifierProvider<PopularFoodNotifier, AsyncValue<List<Map<String, dynamic>>>>(
      (ref) => PopularFoodNotifier(),
);

class PopularFoodNotifier extends StateNotifier<AsyncValue<List<Map<String, dynamic>>>> {
  PopularFoodNotifier() : super(const AsyncValue.loading()) {
    fetchPopularItems();
  }

  Future<void> fetchPopularItems() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final snapshot = await firestore.collection('popular').get();

      final items = snapshot.docs.map((doc) => doc.data()).toList();
      state = AsyncValue.data(items);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
