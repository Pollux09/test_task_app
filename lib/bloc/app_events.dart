import 'package:cloud_firestore/cloud_firestore.dart';

abstract class AppEvents {}


class AddUserEvent extends AppEvents {}

class switchModalWindowVisible extends AppEvents {
  final bool modalVisible;

  switchModalWindowVisible({required this.modalVisible});
}

class LoadProductsList extends AppEvents {
  final String? category;

  LoadProductsList({this.category});
}

class LoadCategoriesList extends AppEvents {}

class LoadProductScreen extends AppEvents {
  final String productId;

  LoadProductScreen({required this.productId});
}

class LoadSelfPickUpScreen extends AppEvents {}

class AddProductToBasket extends AppEvents {
  final String productId;
  final String packaging;

  AddProductToBasket({required this.productId, required this.packaging});
}

class LoadBasketScreen extends AppEvents {}

class DeleteProductFromBasket extends AppEvents {
  final String productId;

  DeleteProductFromBasket({required this.productId});
}

class CreateOrder extends AppEvents {
  final List productsList;
  final String phone;
  final String comment;
  final String adress;

  CreateOrder({
    required this.productsList,
    required this.phone,
    required this.comment,
    required this.adress,
  });
}

class DeleteProductFromBasketCatalog extends AppEvents {
  final String productId;

  DeleteProductFromBasketCatalog({required this.productId});
}

class AddProductToBasketCatalog extends AppEvents {
  final String productId;
  final String packaging;

  AddProductToBasketCatalog({required this.productId, required this.packaging});
}
