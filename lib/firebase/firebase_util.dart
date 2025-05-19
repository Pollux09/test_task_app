import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseUtil {
  var firestore = FirebaseFirestore.instance;

  Future<List> getAllCategories() async {
    QuerySnapshot querySnapshot = await firestore
        .collection('categories')
        .get();

    final categoriesList = querySnapshot.docs as List;
    return categoriesList;
  }

  Future<List<Map<String, dynamic>>> getProducts([String? category]) async {
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('products')
          .get();
      final List<Map<String, dynamic>> finalProductList = [];

      for (var productDoc in querySnapshot.docs) {
        Map<String, dynamic> productData =
            productDoc.data() as Map<String, dynamic>;

        // Проверяем наличие ссылки на категорию
        if (productData.containsKey('category') &&
            productData['category'] is DocumentReference) {
          DocumentReference categoryRef =
              productData['category'] as DocumentReference;
          DocumentSnapshot categorySnapshot = await categoryRef.get();

          if (categorySnapshot.exists) {
            Map<String, dynamic>? categoryData =
                categorySnapshot.data() as Map<String, dynamic>?;

            if (categoryData != null) {
              productData['categoryName'] = categoryData['name'];
              productData['productId'] = productDoc.id;
            } else {
              productData['categoryName'] = "Без категории";
            }
          }
          if (category != null) {
            if (categorySnapshot.id == category) {
              finalProductList.add(productData);
            }
          } else {
            finalProductList.add(productData);
          }
        }
      }
      return finalProductList;
    } catch (e) {
      print('Ошибка загрузки продуктов: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> getProductById(String productId) async {
    // Получаем документ продукта по его идентификатору
    DocumentSnapshot<Map<String, dynamic>> docSnapshot = await firestore
        .collection('products')
        .doc(productId)
        .get();

    if (!docSnapshot.exists) {
      throw Exception('Продукт с id $productId не найден');
    }

    Map<String, dynamic> result = docSnapshot.data()!;
    result['productId'] = docSnapshot.id;

    if (result.containsKey('category') &&
        result['category'] is DocumentReference) {
      DocumentReference categoryRef = result['category'] as DocumentReference;
      DocumentSnapshot categorySnapshot = await categoryRef.get();

      if (categorySnapshot.exists) {
        Map<String, dynamic>? categoryData =
            categorySnapshot.data() as Map<String, dynamic>?;

        result['categoryName'] = categoryData?['name'] ?? 'Без категории';
      } else {
        result['categoryName'] = 'Без категории';
      }
    }

    return result;
  }

  Future<List<Map>> getLocations() async {
    List<Map> locations = [];
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('addresses').get();

      for (final doc in querySnapshot.docs) {
        final data = doc.data();
        if (data != null) {
          locations.add(data);
        }
      }
    } catch (e) {
      print('Ошибка при загрузке адресов: $e');
    }

    return locations;
  }

  Future<bool> addOrder(
    List<Map> orders,
    String phone,
    String comment,
    String address,
  ) async {
    try {
      final addressesSnapshot = await FirebaseFirestore.instance
          .collection('addresses')
          .get();

      var check = addressesSnapshot.docs;


      // 3. Подготовка данных
      final validLocations = addressesSnapshot.docs
          .map(
            (doc) =>
                doc['location_title']?.toString().trim().toLowerCase() ?? '',
          )
          .where((location) => location.isNotEmpty)
          .toList();

      final userAddress = address.trim().toLowerCase();

      // 4. Проверка совпадений
      final isDeliveryAvailable = validLocations.any(
        (location) => userAddress.contains(location),
      );

      if (!isDeliveryAvailable) return false;

      // 5. Создание заказа
      await FirebaseFirestore.instance.collection('orders').add({
        'phone': phone,
        'comment': comment,
        'productsList': orders,
        'address': address,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e) {
      print('Ошибка: ${e.toString()}');
      return false;
    }
  }
}

FirebaseUtil firebaseUtil = FirebaseUtil();
