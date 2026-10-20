import 'package:flutter/material.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product, required this.onTap, required this.onEdit, required this.onDelete, required this.isFavorite, required this.onFavorite});
  final Product product;
  final VoidCallback onTap, onEdit, onDelete, onFavorite;
  final bool isFavorite;
  @override Widget build(BuildContext context) => Card(
        clipBehavior: Clip.antiAlias,
        elevation: 3,
        shadowColor: AppTheme.pink.withValues(alpha: .2),
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        child: InkWell(onTap: onTap, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Stack(children: [Hero(tag: 'product-${product.id}', child: Container(height: 125, width: double.infinity, color: const Color(0xFFFFE2EF), padding: const EdgeInsets.all(14), child: Image.network(product.image, fit: BoxFit.contain, errorBuilder: (_, _, _) => const Icon(Icons.image_not_supported_outlined, color: AppTheme.lavender)))), Positioned(right: 8, top: 8, child: CircleAvatar(radius: 16, backgroundColor: Colors.white, child: IconButton(padding: EdgeInsets.zero, iconSize: 18, onPressed: onFavorite, icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: AppTheme.hotPink))))]),
          Padding(padding: const EdgeInsets.fromLTRB(10, 8, 10, 9), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(product.category, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppTheme.hotPink, fontSize: 10, fontWeight: FontWeight.w600)), const SizedBox(height: 4), Text(product.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700, height: 1.2, fontSize: 12)), const SizedBox(height: 5), Text('\$${product.price.toStringAsFixed(2)}', style: const TextStyle(color: AppTheme.lavender, fontWeight: FontWeight.w700)), Row(children: [IconButton(visualDensity: VisualDensity.compact, onPressed: onEdit, icon: const Icon(Icons.edit_outlined, size: 18, color: AppTheme.lavender)), const Spacer(), IconButton(visualDensity: VisualDensity.compact, onPressed: onDelete, icon: const Icon(Icons.delete_outline, size: 18, color: AppTheme.hotPink))])]))
        ])),
      );
}

