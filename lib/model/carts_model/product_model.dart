class ProductModel {
  int? id;
  String? title;
  double? price;
  int? quantity;
  double? total;
  double? discountPercentage;
  double? discountedTotal;
  String? thumbnail;

  ProductModel({
    this.id,
    this.title,
    this.price,
    this.quantity,
    this.total,
    this.discountPercentage,
    this.discountedTotal,
    this.thumbnail,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['title'],
      price: (json['price'] as num?)?.toDouble(),
      quantity: json['quantity'],
      total: (json['total'] as num?)?.toDouble(),
      discountPercentage: (json['discountPercentage'] as num?)?.toDouble(),
      discountedTotal: (json['discountedTotal'] as num?)?.toDouble(),
      thumbnail: json['thumbnail'],
    );
  }

  Map<String, dynamic> toMap(int cartId) {
    return {
      'id': id,
      'title': title,
      'price': price,
      'quantity': quantity,
      'total': total,
      'discountPercentage': discountPercentage,
      'discountedTotal': discountedTotal,
      'thumbnail': thumbnail,
      'cartId': cartId,
    };
  }
}
