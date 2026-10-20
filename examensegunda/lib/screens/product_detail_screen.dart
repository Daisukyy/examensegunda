import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/product_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/gradient_button.dart';
import '../widgets/sakura_background.dart';
import 'product_form_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.product});
  final Product product;

  Future<void> _delete(BuildContext context) async {
    final confirmed = await showDialog<bool>(context: context, builder: (context) => AlertDialog(
      title: const Text('\u00bfEliminar producto?'),
      content: Text('Se eliminar\u00e1 "${product.title}" de la lista.'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
        TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Eliminar')),
      ],
    ));
    if (confirmed != true || !context.mounted) return;
    try {
      await context.read<ProductProvider>().deleteProduct(product);
      if (context.mounted) Navigator.pop(context);
    } catch (_) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No se pudo eliminar el producto.')));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Stack(children: [
          const Positioned.fill(child: SakuraBackground(opacity: .2)),
          SafeArea(child: Column(children: [
            Expanded(flex: 5, child: Stack(children: [
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFFFFD5E7), Color(0xFFE4D8FF)]), borderRadius: BorderRadius.vertical(bottom: Radius.circular(42))),
                child: Center(child: Hero(tag: 'product-${product.id}', child: Container(
                  height: 250,
                  width: 250,
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(color: Colors.white70, shape: BoxShape.circle),
                  child: Image.network(product.image, fit: BoxFit.contain, errorBuilder: (context, error, stack) => const Icon(Icons.image_not_supported_outlined, size: 60)),
                ))),
              ),
              Positioned(left: 16, top: 12, child: CircleAvatar(backgroundColor: Colors.white, child: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back, color: AppTheme.ink)))),
            ])),
            Expanded(flex: 6, child: Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 18),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28), boxShadow: [BoxShadow(color: AppTheme.pink.withValues(alpha: .16), blurRadius: 18, offset: const Offset(0, 8))]),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5), decoration: BoxDecoration(color: const Color(0xFFFFE2EF), borderRadius: BorderRadius.circular(20)), child: Text(product.category, style: const TextStyle(color: AppTheme.hotPink, fontSize: 12))),
                const SizedBox(height: 10),
                Text(product.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
                const SizedBox(height: 6),
                Row(children: [const Icon(Icons.star, color: Colors.amber), Text(' ${product.rating.rate.toStringAsFixed(1)} \u00b7 ${product.rating.count} rese\u00f1as', style: const TextStyle(color: Colors.black45, fontSize: 12))]),
                Text('\$${product.price.toStringAsFixed(2)}', style: const TextStyle(color: AppTheme.lavender, fontSize: 27, fontWeight: FontWeight.w700)),
                const Text('Descripci\u00f3n', style: TextStyle(color: AppTheme.pink, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Expanded(child: SingleChildScrollView(child: Text(product.description))),
                Row(children: [
                  Expanded(child: GradientButton(label: 'Editar', icon: Icons.edit_outlined, onPressed: () async {
                    final saved = await Navigator.push<bool>(context, MaterialPageRoute(builder: (_) => ProductFormScreen(product: product)));
                    if (saved == true && context.mounted) Navigator.pop(context);
                  })),
                  const SizedBox(width: 10),
                  Expanded(child: OutlinedButton.icon(onPressed: () => _delete(context), icon: const Icon(Icons.delete_outline), label: const Text('Eliminar'), style: OutlinedButton.styleFrom(foregroundColor: AppTheme.hotPink, minimumSize: const Size.fromHeight(52), shape: const StadiumBorder()))),
                ]),
              ]),
            )),
          ])),
        ]),
      );
}
