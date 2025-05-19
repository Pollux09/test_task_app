import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_task_app/bloc/app_bloc.dart';
import 'package:test_task_app/bloc/app_events.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.title,
    required this.description,
    required this.price,
    required this.productComposition,
    required this.imagesUrls,
    required this.categoryName,
    required this.productId,
    required this.countInBasket,
    required this.packaging,
  });

  final String title;
  final String description;
  final int price;
  final String productComposition;
  final List imagesUrls;
  final String? categoryName;
  final String productId;
  final int countInBasket;
  final String packaging;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Фиксированный блок для изображения
          AspectRatio(
            aspectRatio: 1.5,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              child: Image.network(
                imagesUrls.isNotEmpty ? imagesUrls[0] : '',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.broken_image),
                ),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title.toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12.0,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (categoryName != null) const Icon(Icons.speed_sharp, size: 16),
              const SizedBox(width: 6),
              Text(
                categoryName ?? 'Без категории',
                style: const TextStyle(fontSize: 16, color: Color(0xFF797474)),
              ),
            ],
          ),
          const Spacer(),
          if (countInBasket > 0)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    context.read<AppBloc>().add(
                      DeleteProductFromBasketCatalog(productId: productId),
                    );
                  },
                  icon: const Icon(Icons.remove, size: 20),
                ),
                const SizedBox(width: 8),
                Text(
                  countInBasket.toString(),
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 8),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    context.read<AppBloc>().add(
                      AddProductToBasketCatalog(
                        productId: productId,
                        packaging: packaging,
                      ),
                    );
                  },
                  icon: const Icon(Icons.add, size: 20),
                ),
              ],
            ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF427A5B),
                padding: EdgeInsets.symmetric(vertical: 8),
              ),
              onPressed: () {
                Navigator.of(
                  context,
                ).pushNamed("/productScreen", arguments: productId);
              },
              child: const Text(
                "Подробнее",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
