import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../utils/constants.dart';

class ProductService {
  ProductService({http.Client? client}) : _client = client ?? http.Client();
  final http.Client _client;
  Future<List<Product>> getProducts() async {
    final response = await _client.get(Uri.parse('$kBaseUrl/products')).timeout(const Duration(seconds: 20));
    if (response.statusCode != 200) throw HttpException('La API respondió con error (${response.statusCode}).');
    return (jsonDecode(response.body) as List<dynamic>).map((item) => Product.fromJson(item as Map<String, dynamic>)).toList();
  }
  Future<Product> createProduct(Product product) => _send('POST', product);
  Future<Product> updateProduct(Product product) => _send('PUT', product, id: product.id);
  Future<void> deleteProduct(int id) async {
    final response = await _client.delete(Uri.parse('$kBaseUrl/products/$id')).timeout(const Duration(seconds: 20));
    if (response.statusCode < 200 || response.statusCode >= 300) throw HttpException('No se pudo eliminar el producto (${response.statusCode}).');
  }
  Future<Product> _send(String method, Product product, {int? id}) async {
    final uri = Uri.parse('$kBaseUrl/products${id == null ? '' : '/$id'}');
    final response = method == 'POST'
        ? await _client.post(uri, headers: {'Content-Type': 'application/json'}, body: jsonEncode(product.toJson())).timeout(const Duration(seconds: 20))
        : await _client.put(uri, headers: {'Content-Type': 'application/json'}, body: jsonEncode(product.toJson())).timeout(const Duration(seconds: 20));
    if (response.statusCode < 200 || response.statusCode >= 300) throw HttpException('No se pudo guardar el producto (${response.statusCode}).');
    final body = response.body.isEmpty ? <String, dynamic>{} : jsonDecode(response.body) as Map<String, dynamic>;
    return Product.fromJson({...product.toJson(), ...body, 'id': body['id'] ?? product.id});
  }
}
