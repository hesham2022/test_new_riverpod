import 'dart:convert';

Cart cartFromJson(String str) => Cart.fromJson(json.decode(str));

String cartToJson(Cart data) => json.encode(data.toJson());

class Cart {
  Cart({
    required this.success,
    required this.products,
    required this.totalShippingCardPrice,
  });

  bool success;
  List<Product> products;
  int totalShippingCardPrice;

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        success: json["success"],
        products: List<Product>.from(
            json["products"].map((x) => Product.fromJson(x))),
        totalShippingCardPrice: json["total shipping card price"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
        "total shipping card price": totalShippingCardPrice,
      };
}

class Product {
  Product({
    required this.id,
    required this.productId,
    required this.name,
    required this.mainStock,
    required this.image,
    required this.price,
    required this.quantity,
  });

  int id;
  int productId;
  String name;
  int mainStock;
  String image;
  int price;
  int quantity;
  void increaseQuantity() {
    quantity = quantity + 1;
    print('quanaty is $quantity ');
  }
    void decreaseQuantity() {
    quantity = quantity - 1;
    print('quanaty is $quantity ');
  }

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        productId: json["product_id"],
        name: json["name"],
        mainStock: json["main_stock"],
        image: json["image"],
        price: json["price"],
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "name": name,
        "main_stock": mainStock,
        "image": image,
        "price": price,
        "quantity": quantity,
      };
}
