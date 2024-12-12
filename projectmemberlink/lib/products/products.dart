class Product {
  String? productId;
  String? productTitle;
  String? productDescription;
  String? productImage;
  int? productQuantity;
  double? productPrice;
  String? productType;

  Product({
    this.productId,
    this.productTitle,
    this.productDescription,
    this.productImage,
    this.productQuantity,
    this.productPrice,
    this.productType,
  });

  Product.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productTitle = json['product_title'];
    productDescription = json['product_description'];
    productImage = json['product_image'];

    productQuantity = json['product_quantity'] is String
        ? int.tryParse(json['product_quantity'])
        : json['product_quantity'] as int?;

    productPrice = json['product_price'] is String
        ? double.tryParse(json['product_price'])
        : json['product_price']?.toDouble();

    productType = json['product_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['product_title'] = productTitle;
    data['product_description'] = productDescription;
    data['product_image'] = productImage;
    data['product_quantity'] = productQuantity;
    data['product_price'] = productPrice;
    data['product_type'] = productType;
    return data;
  }
}
