import 'package:dio/dio.dart';
import 'package:route_task/models/product_model.dart';

class ProductService {
  final Dio _dio = Dio();

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await _dio.get('https://dummyjson.com/products');

      if (response.statusCode == 200) {
        List<Product> products = (response.data['products'] as List)
            .map((productJson) => Product.fromJson(productJson))
            .toList();
        return products;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }
}
