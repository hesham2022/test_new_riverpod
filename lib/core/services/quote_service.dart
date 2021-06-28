import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:test_new_riverpod/core/constants/api_constants.dart';
import 'package:test_new_riverpod/core/models/cart_model.dart';

class QuoteService {
  QuoteService._();
  static final instance = QuoteService._();

  final url = ApiConstants.BASE_URL + ApiConstants.CART;
  String token =
      'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczpcL1wvc3RvcmtzdG9yZXMuY29tXC9hcGlcL3VzZXJzXC9sb2dpbiIsImlhdCI6MTYyNDg5NTgyMywibmJmIjoxNjI0ODk1ODIzLCJqdGkiOiJKa3c2MTdiMXl1cEIxMkNqIiwic3ViIjoxNzIsInBydiI6Ijg3ZTBhZjFlZjlmZDE1ODEyZmRlYzk3MTUzYTE0ZTBiMDQ3NTQ2YWEifQ.39zw6d2En992XvobVADSQ3Q12epWq2Wyp77DUgtmqbk';

  Future<Cart> getQuotes() async {
    Dio dio = new Dio();
    dio.options.headers["Authorization"] = "Bearer $token";
    final response = await dio.get(
      url,
    );
    Cart cart = Cart.fromJson(response.data);
    return cart;
  }

  Future changeProduct(String id, BuildContext context, String url) async {
    Dio dio = new Dio();
    dio.options.headers["Authorization"] = "Bearer $token";
    var response = await dio.post(url, data: {'id': id, "lang": 'ar'});
    print(response.data['message'].toString());
    Scaffold.of(context).showSnackBar(
        SnackBar(content: Text(response.data['message'].toString())));
    // notifyListeners();
  }
}
