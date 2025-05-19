import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_task_app/hiveStorage/basket.dart';

abstract class AppStates {}

class InitialState extends AppStates {}

class CheckState extends AppStates {
  final String checkValue;

  CheckState({required this.checkValue});
}

class ModalWindowVisible extends AppStates {
  final bool isVisible;

  ModalWindowVisible({required this.isVisible});
}

class ProductsListState extends AppStates {
  final List<Map> productsList;
  final List<Basket> basketProducts;

  ProductsListState({required this.productsList, required this.basketProducts});
}

class CategoriesListState extends AppStates {
  final List categoriesList;

  CategoriesListState({required this.categoriesList});
}

class LoadedProductScreen extends AppStates {
  final Map product;

  LoadedProductScreen({required this.product});
}

class LoadedSelfPickUpScreen extends AppStates {
  final List<Map> locations;

  LoadedSelfPickUpScreen({required this.locations});
}

class LoadedBasketScreen extends AppStates {
  final List<Map> productsList;

  LoadedBasketScreen({required this.productsList});
}


class OrderCreatedSuccess extends AppStates {}

class DontSupportedCity extends AppStates {}
