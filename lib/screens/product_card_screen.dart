import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:test_task_app/bloc/app_bloc.dart';
import 'package:test_task_app/bloc/app_events.dart';
import 'package:test_task_app/bloc/app_states.dart';

class ProductCardScreen extends StatefulWidget {
  static const double _thumbnailSize = 80.0;
  static const double _gridPadding = 8.0;
  static const double _gridBorderRadius = 8.0;
  static const double _mainAspectRatio = 1.0;

  const ProductCardScreen({super.key});

  @override
  State<ProductCardScreen> createState() => _ProductCardScreenState();
}

class _ProductCardScreenState extends State<ProductCardScreen> {
  int? currentIndexOfPackaging;
  int selectedImageIndex = 0;
  int currentInfoSwitcherIndex = 0;
  bool isVisible = false;

  void changeCurrentInfoIndex(int newIndex) {
    setState(() {
      currentInfoSwitcherIndex = newIndex;
    });
  }

  void switchVisible(bool value) {
    setState(() {
      isVisible = value;
    });
  }

  void changePackagingIndex(int newIndex) {
    setState(() {
      currentIndexOfPackaging = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    String productId = ModalRoute.of(context)!.settings.arguments as String;
    final double screenHeight = MediaQuery.of(context).size.height / 3;

    return BlocProvider(
      create: (context) =>
          AppBloc()..add(LoadProductScreen(productId: productId)),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight + 10),
              child: AppBar(
                backgroundColor: Colors.white,
                leading: Align(
                  alignment: Alignment.center,
                  child: Container(
                    margin: EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                      color: Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      padding: EdgeInsets.all(8),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
                actions: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: EdgeInsets.only(right: 16),
                      decoration: BoxDecoration(color: Colors.transparent),
                      child: IconButton(
                        icon: Icon(Icons.local_grocery_store),
                        padding: EdgeInsets.all(8),
                        onPressed: () =>
                            Navigator.of(context).pushNamed("/basketScreen"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            body: BlocBuilder<AppBloc, AppStates>(
              builder: (context, state) {
                return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.white, Color(0xFFE4F0E4)],
                    ),
                  ),
                  child: Stack(
                    children: [
                      if (state is LoadedProductScreen)
                        ListView(
                          padding: const EdgeInsets.only(
                            top: 18.0,
                            left: 16.0,
                            right: 16.0,
                            bottom: 16.0,
                          ),
                          children: [
                            SizedBox(
                              height: screenHeight,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: ProductCardScreen._thumbnailSize,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount:
                                          state.product['images_urls'].length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedImageIndex = index;
                                            });
                                          },
                                          child: Padding(
                                            key: ValueKey('thumbnail_$index'),
                                            padding: const EdgeInsets.only(
                                              bottom: ProductCardScreen
                                                  ._gridPadding,
                                              left: ProductCardScreen
                                                  ._gridPadding,
                                              right: ProductCardScreen
                                                  ._gridPadding,
                                            ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color:
                                                      selectedImageIndex ==
                                                          index
                                                      ? const Color(0xFF427A5B)
                                                      : Colors.transparent,
                                                  width: 2,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      ProductCardScreen
                                                          ._gridBorderRadius,
                                                    ),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      ProductCardScreen
                                                              ._gridBorderRadius -
                                                          2,
                                                    ),
                                                child: AspectRatio(
                                                  aspectRatio: 1,
                                                  child: Image.network(
                                                    state
                                                        .product['images_urls'][index],
                                                    fit: BoxFit.cover,
                                                    cacheWidth:
                                                        ProductCardScreen
                                                            ._thumbnailSize
                                                            .toInt(),
                                                    loadingBuilder:
                                                        (
                                                          context,
                                                          child,
                                                          progress,
                                                        ) {
                                                          return progress ==
                                                                  null
                                                              ? child
                                                              : const Center(
                                                                  child: CircularProgressIndicator(
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                );
                                                        },
                                                    errorBuilder:
                                                        (
                                                          context,
                                                          error,
                                                          stackTrace,
                                                        ) {
                                                          return const Icon(
                                                            Icons.error_outline,
                                                            color: Colors.red,
                                                          );
                                                        },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    width: ProductCardScreen._gridPadding,
                                  ),
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius:
                                          const BorderRadius.horizontal(
                                            left: Radius.circular(12.0),
                                          ),
                                      child: AspectRatio(
                                        aspectRatio:
                                            ProductCardScreen._mainAspectRatio,
                                        child: Image.network(
                                          state
                                              .product['images_urls'][selectedImageIndex],
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                return const Center(
                                                  child: Icon(
                                                    Icons.error_outline,
                                                    size: 50.0,
                                                    color: Colors.red,
                                                  ),
                                                );
                                              },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 32.0),
                            Text(
                              state.product['title'],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 28.0,
                                fontWeight: FontWeight.w800,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 12.0),
                            Row(
                              children: [
                                const Icon(Icons.access_alarms),
                                const SizedBox(width: 8.0),
                                Text(
                                  state.product['categoryName'],
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 22.0),
                            const Text(
                              'Выбрать фасовку',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            if (state.product['packaging'] != null)
                              Row(
                                children: [
                                  Expanded(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: List.generate(
                                          state.product['packaging'].length,
                                          (index) => buildPackageButton(
                                            context,
                                            state.product['packaging'][index],
                                            index,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            const SizedBox(height: 40.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: currentInfoSwitcherIndex == 0
                                              ? const Color(0xFF427A5B)
                                              : const Color(0xFF797474),
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    child: TextButton(
                                      onPressed: () {
                                        changeCurrentInfoIndex(0);
                                      },
                                      child: Text(
                                        'Описание',
                                        style: TextStyle(
                                          color: currentInfoSwitcherIndex == 0
                                              ? const Color(0xFF427A5B)
                                              : const Color(0xFF797474),
                                          fontSize: 18.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: currentInfoSwitcherIndex == 1
                                              ? const Color(0xFF427A5B)
                                              : const Color(0xFF797474),
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    child: TextButton(
                                      onPressed: () {
                                        changeCurrentInfoIndex(1);
                                      },
                                      child: Text(
                                        'Состав',
                                        style: TextStyle(
                                          color: currentInfoSwitcherIndex == 1
                                              ? const Color(0xFF427A5B)
                                              : const Color(0xFF797474),
                                          fontSize: 18.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30.0),
                            Text(
                              currentInfoSwitcherIndex == 0
                                  ? state.product['description']
                                  : state.product['product_composition'],
                              style: TextStyle(
                                fontSize: 16.0,
                                height: 1.4,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 40.0),
                            Container(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "\$${state.product['price']}",
                                        style: TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            backgroundColor: const Color(
                                              0xFF427A5B,
                                            ),
                                            padding: const EdgeInsets.all(16.0),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                          ),
                                          onPressed: () {
                                            if (currentIndexOfPackaging != null) {
                                              context.read<AppBloc>().add(
                                                AddProductToBasket(
                                                  productId: productId,
                                                  packaging: state
                                                      .product['packaging'][currentIndexOfPackaging],
                                                ),
                                              );
                                            }
                                          },
                                          child: const Text(
                                            'В корзину',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 22.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    width: double.infinity,
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor:
                                            currentIndexOfPackaging != null
                                            ? const Color(0xFF427A5B)
                                            : const Color(0xFF929493),
                                        padding: const EdgeInsets.all(16.0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            15.0,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        if (currentIndexOfPackaging != null) {
                                          switchVisible(true);
                                        }
                                      },
                                      child: const Text(
                                        'Заказать',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      if (isVisible)
                        Stack(
                          children: [
                            ModalBarrier(
                              color: Colors.black.withOpacity(0.5),
                              dismissible: true,
                              onDismiss: () => switchVisible(false),
                            ),
                            Center(
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Как вы хотите забрать товар?',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      const SizedBox(height: 24.0),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(
                                            context,
                                          ).pushNamed("/deliveryScreen");
                                        },
                                        style: TextButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFF427A5B,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 18,
                                            horizontal: 46,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              15.0,
                                            ),
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
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(
                                            context,
                                          ).pushNamed("/selfPickUpScreen");
                                        },
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors.grey,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 18,
                                            horizontal: 38,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              15.0,
                                            ),
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
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget buildPackageButton(BuildContext context, String package, int index) {
    return Container(
      margin: const EdgeInsets.only(right: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1.0),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: SizedBox(
        width: 56.0,
        height: 56.0,
        child: TextButton(
          onPressed: () {
            changePackagingIndex(index);
          },
          style: TextButton.styleFrom(
            backgroundColor: currentIndexOfPackaging == index
                ? const Color(0xFF3B3B3B)
                : const Color(0xFFE9E9E9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2.0),
            ),
          ),
          child: Text(
            package,
            style: TextStyle(
              color: currentIndexOfPackaging == index
                  ? Colors.white
                  : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
