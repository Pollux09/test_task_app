import 'package:hive/hive.dart';

part 'basket.g.dart';

@HiveType(typeId: 1)
class Basket extends HiveObject {
  @HiveField(0)
  final String productId;

  @HiveField(1)
  final String packaging;

  Basket(this.productId, this.packaging);

  Basket copyWith({
  String? productId,
  String? packaging,
  }) {
    return Basket(
      productId ?? this.productId,
      packaging ?? this.packaging,
    );
  }
}