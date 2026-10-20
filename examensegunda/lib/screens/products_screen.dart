import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/auth_provider.dart';
import '../providers/product_provider.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';
import '../widgets/category_chip.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_view.dart';
import '../widgets/product_card.dart';
import '../widgets/sakura_background.dart';
import 'product_detail_screen.dart';
import 'product_form_screen.dart';
import 'login_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});
  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final _search = TextEditingController();
  String _query = '';
  String? _category;
  final Set<int> _favorites = {};

  void _logout() {
    context.read<AuthProvider>().logout();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<ProductProvider>().loadProducts(),
    );
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _delete(Product product) async {
    final answer = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('\u00bfEliminar producto?'),
        content: Text('Se eliminar\u00e1 "${product.title}" de la lista.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (answer != true || !mounted) return;
    try {
      await context.read<ProductProvider>().deleteProduct(product);
    } catch (_) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo eliminar. Revisa tu conexi\u00f3n.'),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(
      children: [
        const Positioned.fill(child: SakuraBackground(opacity: .25)),
        SafeArea(
          child: Consumer<ProductProvider>(
            builder: (context, provider, _) {
              final filtered = provider.products
                  .where(
                    (product) =>
                        product.title.toLowerCase().contains(
                          _query.toLowerCase(),
                        ) &&
                        (_category == null || product.category == _category),
                  )
                  .toList();

              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFFFAFCF), Color(0xFFCAB7FF)],
                      ),
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(32),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Productos',
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ),
                            IconButton(
                              tooltip: 'Cerrar sesión',
                              onPressed: _logout,
                              icon: const Icon(
                                Icons.logout_rounded,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${provider.products.length} cositas lindas para ti',
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _search,
                          onChanged: (value) => setState(() => _query = value),
                          decoration: InputDecoration(
                            hintText: 'Buscar productos...',
                            prefixIcon: const Icon(Icons.search_rounded),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 8,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(28),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 54,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.fromLTRB(16, 7, 8, 2),
                      children: [
                        CategoryChip(
                          label: 'Todos',
                          selected: _category == null,
                          onSelected: (_) => setState(() => _category = null),
                        ),
                        ...kCategories.map(
                          (category) => CategoryChip(
                            label: category,
                            selected: _category == category,
                            onSelected: (_) => setState(
                              () => _category = _category == category
                                  ? null
                                  : category,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: provider.isLoading && provider.products.isEmpty
                        ? const LoadingView()
                        : provider.error != null && provider.products.isEmpty
                        ? ErrorView(
                            message: provider.error!,
                            onRetry: provider.loadProducts,
                          )
                        : filtered.isEmpty
                        ? RefreshIndicator(
                            onRefresh: provider.loadProducts,
                            child: ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: const [
                                SizedBox(height: 100),
                                Icon(
                                  Icons.search_off_rounded,
                                  size: 52,
                                  color: AppTheme.lavender,
                                ),
                                SizedBox(height: 12),
                                Center(child: Text('No encontramos productos')),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: provider.loadProducts,
                            child: GridView.builder(
                              padding: const EdgeInsets.fromLTRB(
                                14,
                                6,
                                14,
                                100,
                              ),
                              physics: const AlwaysScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 260,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                    childAspectRatio: .66,
                                  ),
                              itemCount: filtered.length,
                              itemBuilder: (context, index) {
                                final product = filtered[index];
                                return ProductCard(
                                  product: product,
                                  isFavorite: _favorites.contains(product.id),
                                  onFavorite: () => setState(
                                    () => _favorites.contains(product.id)
                                        ? _favorites.remove(product.id)
                                        : _favorites.add(product.id),
                                  ),
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          ProductDetailScreen(product: product),
                                    ),
                                  ),
                                  onEdit: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          ProductFormScreen(product: product),
                                    ),
                                  ),
                                  onDelete: () => _delete(product),
                                );
                              },
                            ),
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ProductFormScreen()),
      ),
      backgroundColor: AppTheme.hotPink,
      foregroundColor: Colors.white,
      child: const Icon(Icons.add_rounded),
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
  );
}
