import 'package:hive_flutter/hive_flutter.dart';
import 'package:test_task_app/hiveStorage/basket.dart';

class BasketBoxService {
  Box<Basket> get box => Hive.box<Basket>("basket");

  Future<List<Basket>> getBasketItems() async {
    final values = box.values.toList();
    return values;
  }

  void addItemToBasket(String productId, String packaging) {
    box.add(Basket(productId, packaging));
  }

  Future<void> deleteBasketItem(String productId) async {
    try {
      final keys = box.keys.toList();
      for (final key in keys) {
        final item = box.get(key);
        if (item is Basket && item.productId == productId) {
          await box.delete(key);
          return;
        }
      }
    } catch (e) {
      print('Delete error: $e');
    }
  }

  Future<void> clearBox() async {
    await box.clear();
  }
}

BasketBoxService basketBoxService = BasketBoxService();
