import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_task_app/bloc/app_events.dart';
import 'package:test_task_app/bloc/app_states.dart';
import 'package:test_task_app/firebase/firebase_util.dart';
import 'package:test_task_app/hiveService/basket_box_service.dart';
import 'package:test_task_app/hiveService/user_box_service.dart';
import 'package:test_task_app/hiveStorage/basket.dart';

class AppBloc extends Bloc<AppEvents, AppStates> {
  AppBloc() : super(InitialState()) {
    on<AddUserEvent>(addUser);
    on<switchModalWindowVisible>(openModalWindow);
    on<LoadCategoriesList>(loadCatgoriesList);
    on<LoadProductsList>(loadProductsList);
    on<LoadProductScreen>(loadProductScreen);
    on<LoadSelfPickUpScreen>(getLocations);
    on<AddProductToBasket>(addProductToBusket);
    on<LoadBasketScreen>(loadBasketItems);
    on<DeleteProductFromBasket>(deleteProductFromBasket);
    on<CreateOrder>(createOrder);
    on<DeleteProductFromBasketCatalog>(deleteProductFromBasketCatalog);
    on<AddProductToBasketCatalog>(addProductToBusketCatalog);
  }

  void loadProductsList(event, emit) async {
    List<Map<String, dynamic>> products = event.category != null
        ? await firebaseUtil.getProducts(event.category)
        : await firebaseUtil.getProducts();

    List<Basket> basketProducts = await basketBoxService.getBasketItems();

    emit(
      ProductsListState(productsList: products, basketProducts: basketProducts),
    );
  }

  void loadCatgoriesList(event, emit) async {
    List categories = await firebaseUtil.getAllCategories();
    emit(CategoriesListState(categoriesList: categories));
  }

  void addUser(event, emit) async {
    await userBoxService.addUser();
  }

  bool checkWasIntrodution() {
    return userBoxService.checkWasIntrodution();
  }

  void openModalWindow(event, emit) {
    emit(ModalWindowVisible(isVisible: event.modalVisible));
  }

  void loadProductScreen(event, emit) async {
    Map product = await firebaseUtil.getProductById(event.productId);
    emit(LoadedProductScreen(product: product));
  }

  void getLocations(event, emit) async {
    List<Map> adresses = await firebaseUtil.getLocations();
    emit(LoadedSelfPickUpScreen(locations: adresses));
  }

  void addProductToBusket(event, emit) async {
    basketBoxService.addItemToBasket(event.productId, event.packaging);
  }

  Future<void> loadBasketItems(event, emit) async {
    List<Basket> basketItems = await basketBoxService.getBasketItems();
    List<Map<String, dynamic>> products = [];

    if (basketItems.isNotEmpty) {
      List<Map<String, dynamic>> fetchedProducts = await Future.wait(
        basketItems.map((basket) async {
          Map<String, dynamic> product = await firebaseUtil.getProductById(
            basket.productId,
          );
          product['packaging'] = basket.packaging;
          return product;
        }),
      );
      products.addAll(fetchedProducts);
    }

    if (!emit.isDone) {
      emit(LoadedBasketScreen(productsList: products));
    }
  }

  void deleteProductFromBasket(event, emit) async {
    await basketBoxService.deleteBasketItem(event.productId);
    List<Basket> basketItems = await basketBoxService.getBasketItems();
    List<Map<String, dynamic>> products = [];

    if (basketItems.isNotEmpty) {
      List<Map<String, dynamic>> fetchedProducts = await Future.wait(
        basketItems.map((basket) async {
          Map<String, dynamic> product = await firebaseUtil.getProductById(
            basket.productId,
          );
          product['packaging'] = basket.packaging;
          return product;
        }),
      );
      products.addAll(fetchedProducts);
    }

    if (!emit.isDone) {
      emit(LoadedBasketScreen(productsList: products));
    }
  }

  void deleteProductFromBasketCatalog(event, emit) async {
    await basketBoxService.deleteBasketItem(event.productId);

    List<Map<String, dynamic>> products = await firebaseUtil.getProducts();
    List<Basket> basketProducts = await basketBoxService.getBasketItems();

    emit(
      ProductsListState(productsList: products, basketProducts: basketProducts),
    );
  }

  void addProductToBusketCatalog(event, emit) async {
    basketBoxService.addItemToBasket(event.productId, event.packaging);

    List<Map<String, dynamic>> products = await firebaseUtil.getProducts();
    List<Basket> basketProducts = await basketBoxService.getBasketItems();

    emit(
      ProductsListState(productsList: products, basketProducts: basketProducts),
    );
  }

  void createOrder(event, emit) async {
    bool result = await firebaseUtil.addOrder(
      event.productsList,
      event.phone,
      event.comment,
      event.adress,
    );
    if (result) {
      basketBoxService.clearBox();
      emit(OrderCreatedSuccess());
    } else {
      emit(DontSupportedCity());
    }
  }
}
