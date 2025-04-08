import 'package:local_database/model/carts_model/product_model.dart';

class CartModel {
  int? id;
  List<ProductModel>? products;
  double? total;
  double? discountedTotal;
  int? userId;
  int? totalProducts;
  int? totalQuantity;

  CartModel({
    this.id,
    this.products,
    this.total,
    this.discountedTotal,
    this.userId,
    this.totalProducts,
    this.totalQuantity,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'],
      products:
          (json['products'] as List<dynamic>?)
              ?.map((e) => ProductModel.fromJson(e))
              .toList(),
      total: (json['total'] as num?)?.toDouble(),
      discountedTotal: (json['discountedTotal'] as num?)?.toDouble(),
      userId: json['userId'],
      totalProducts: json['totalProducts'],
      totalQuantity: json['totalQuantity'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'total': total,
      'discountedTotal': discountedTotal,
      'userId': userId,
      'totalProducts': totalProducts,
      'totalQuantity': totalQuantity,
    };
  }
}
