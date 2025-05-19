import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_task_app/bloc/app_bloc.dart';
import 'package:test_task_app/bloc/app_events.dart';
import 'package:test_task_app/bloc/app_states.dart';
import 'package:test_task_app/widgets/basket_product_card.dart';

class BasketScreen extends StatefulWidget {
  const BasketScreen({super.key});

  @override
  State<BasketScreen> createState() => _BasketScreenState();
}

class _BasketScreenState extends State<BasketScreen> {
  bool isVisible = false;

  void switchVisible(bool value) {
    setState(() {
      isVisible = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppBloc()..add(LoadBasketScreen()),
      child: BlocBuilder<AppBloc, AppStates>(
        builder: (context, state) {
          double totalPrice = 0;
          if (state is LoadedBasketScreen) {
            totalPrice = state.productsList.fold<double>(
              0.0,
              (sum, product) => sum + (product['price'] as num).toDouble(),
            );
          }

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: Align(
                alignment: Alignment.center,
                child: Container(
                  margin: const EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    padding: const EdgeInsets.all(8),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
              title: const Text("Корзина"),
            ),
            body: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.white, Color(0xFFE4F0E4)],
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      Expanded(
                        child: state is LoadedBasketScreen
                            ? state.productsList.isNotEmpty
                                  ? ListView(
                                      padding: const EdgeInsets.only(
                                        top: 16,
                                        bottom: 12,
                                      ),
                                      children: [
                                        ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: state.productsList.length,
                                          itemBuilder: (context, index) {
                                            final product =
                                                state.productsList[index];
                                            return BasketProductCard(
                                              title: product['title'],
                                              description:
                                                  product['description'],
                                              price: product['price'],
                                              productComposition:
                                                  product['product_composition'],
                                              imagesUrls:
                                                  product['images_urls'],
                                              categoryName:
                                                  product['categoryName'],
                                              productId: product['productId'],
                                              packaging: product['packaging'],
                                            );
                                          },
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                            horizontal: 16,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'СУММА',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF797474),
                                                ),
                                              ),
                                              Text(
                                                '\$${totalPrice.toStringAsFixed(2)}',
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                            horizontal: 16,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'СТОИМОСТЬ ДОСТАВКИ:',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF797474),
                                                ),
                                              ),
                                              const Text(
                                                "БЕСПЛАТНО",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                            horizontal: 16,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'ВСЕГО:',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF797474),
                                                ),
                                              ),
                                              Text(
                                                '\$${totalPrice.toStringAsFixed(2)}',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  : const Center(child: Text('Пока пусто'))
                            : const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.black,
                                ),
                              ),
                      ),
                      if (state is LoadedBasketScreen &&
                          state.productsList.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 16.0,
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            child: TextButton(
                              onPressed: () => switchVisible(true),
                              style: TextButton.styleFrom(
                                backgroundColor: const Color(0xFF427A5B),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              ),
                              child: const Text(
                                'Оформить заказ',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // Модальное окно поверх всего
                if (isVisible)
                  Positioned.fill(
                    child: ModalBarrier(
                      color: Colors.black.withOpacity(0.5),
                      dismissible: true,
                      onDismiss: () => switchVisible(false),
                    ),
                  ),
                if (isVisible)
                  Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Как вы хотите забрать товар?',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 24.0),
                            if (state is LoadedBasketScreen)
                              TextButton(
                                onPressed: () {
                                  switchVisible(false);
                                  Navigator.of(context).pushNamed(
                                    "/deliveryScreen",
                                    arguments: state.productsList,
                                  );
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: const Color(0xFF427A5B),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 18,
                                    horizontal: 46,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                ),
                                child: const Text(
                                  'Доставка',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 16.0),
                            if (state is LoadedBasketScreen)
                              TextButton(
                                onPressed: () {
                                  switchVisible(false);
                                  Navigator.of(context).pushNamed(
                                    "/selfPickUpScreen",
                                    arguments: state.productsList,
                                  );
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 18,
                                    horizontal: 38,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                ),
                                child: const Text(
                                  'Самовывоз',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
