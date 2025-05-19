import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_task_app/bloc/app_bloc.dart';
import 'package:test_task_app/bloc/app_events.dart';

class BasketProductCard extends StatelessWidget {
  const BasketProductCard({
    super.key,
    required this.title,
    required this.description,
    required this.price,
    required this.productComposition,
    required this.imagesUrls,
    required this.categoryName,
    required this.productId,
    required this.packaging,
  });

  final String title;
  final String description;
  final int price;
  final String productComposition;
  final List imagesUrls;
  final String? categoryName;
  final String productId;
  final String packaging;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: SizedBox(
        width: double.infinity,
        child: Row(
          children: [
            SizedBox(
              width: 140,
              height: 140,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                child: Image.network(imagesUrls[0]),
              ),
            ),
            SizedBox(width: 16.0),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: const Color(0xFF797474),
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              categoryName.toString(),
                              style: TextStyle(
                                color: const Color(0xFF797474),
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          packaging,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: const Color(0xFF797474),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '\$$price',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      context.read<AppBloc>().add(
                        DeleteProductFromBasket(productId: productId),
                      );
                    },
                    icon: Icon(Icons.delete),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
