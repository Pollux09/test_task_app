import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_task_app/bloc/app_bloc.dart';
import 'package:test_task_app/bloc/app_events.dart';
import 'package:test_task_app/bloc/app_states.dart';
import 'package:test_task_app/widgets/product_card.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String? category =
        ModalRoute.of(context)?.settings.arguments as String?;

    return BlocProvider(
      create: (context) => category != null
          ? (AppBloc()..add(LoadProductsList(category: category)))
          : (AppBloc()..add(LoadProductsList())),
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: Padding(
              padding: EdgeInsets.only(left: 8),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("/categoryScreen");
                },
                icon: Icon(Icons.settings),
              ),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 16),
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed("/basketScreen");
                  },
                  icon: Icon(Icons.local_grocery_store),
                ),
              ),
            ],
            title: Text("Каталог товаров"),
          ),
          body: BlocBuilder<AppBloc, AppStates>(
            builder: (context, state) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.white, const Color(0xFFE4F0E4)],
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    if (category != null) SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          category ?? '',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 18.0),
                    state is ProductsListState
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: Text(
                                  "Всего: ${state.productsList.length}",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Row(),
                    Expanded(
                      child: state is ProductsListState
                          ? GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 8.0,
                                    crossAxisSpacing: 8.0,
                                    childAspectRatio: 0.65,
                                  ),
                              itemCount: state.productsList.length,
                              itemBuilder: (context, index) {
                                if (state.productsList[index]['productId'] !=
                                    null) {
                                  return ProductCard(
                                    title: state.productsList[index]['title'],
                                    description: state
                                        .productsList[index]['description'],
                                    price: state.productsList[index]['price'],
                                    productComposition: state
                                        .productsList[index]['product_composition'],
                                    imagesUrls: state
                                        .productsList[index]['images_urls'],
                                    categoryName: state
                                        .productsList[index]['categoryName'],
                                    productId:
                                        state.productsList[index]['productId'],
                                    countInBasket: state.basketProducts
                                        .where(
                                          (element) =>
                                              element.productId ==
                                              state
                                                  .productsList[index]['productId'],
                                        )
                                        .length,
                                    packaging:
                                        state
                                            .productsList[index]['packaging'][0] ??
                                        '',
                                  );
                                }
                              },
                            )
                          : Center(
                              child: CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
