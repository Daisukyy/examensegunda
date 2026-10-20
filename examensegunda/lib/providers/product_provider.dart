import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class ProductProvider extends ChangeNotifier {
  ProductProvider(this._service);
  final ProductService _service;
  List<Product> _products = [];
  bool isLoading = false;
  String? error;
  List<Product> get products => List.unmodifiable(_products);
  Future<void> loadProducts() async {
    isLoading = true; error = null; notifyListeners();
    try { _products = await _service.getProducts(); }
    on SocketException { error = 'No hay conexión a Internet. Revisa tu conexión e inténtalo de nuevo.'; }
    on HttpException catch (e) { error = e.message; }
    catch (_) { error = 'No pudimos cargar los productos. Inténtalo de nuevo.'; }
    finally { isLoading = false; notifyListeners(); }
  }
  Future<void> saveProduct(Product product, {bool isNew = false}) async {
    final saved = isNew ? await _service.createProduct(product) : await _service.updateProduct(product);
    // FakeStoreAPI simula POST/PUT pero no persiste: mantenemos el cambio en memoria para actualizar la UI.
    if (isNew) { _products = [saved.copyWith(id: _nextId()), ..._products]; }
    else { _products = _products.map((item) => item.id == product.id ? saved : item).toList(); }
    notifyListeners();
  }
  Future<void> deleteProduct(Product product) async {
    await _service.deleteProduct(product.id);
    // FakeStoreAPI simula DELETE sin persistirlo; quitamos el producto localmente tras recibir éxito.
    _products = _products.where((item) => item.id != product.id).toList();
    notifyListeners();
  }
  int _nextId() => _products.fold<int>(0, (maxId, item) => item.id > maxId ? item.id : maxId) + 1;
}
