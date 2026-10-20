import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/product_provider.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';
import '../utils/validators.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/gradient_button.dart';
import '../widgets/sakura_background.dart';

class ProductFormScreen extends StatefulWidget {
  const ProductFormScreen({super.key, this.product});
  final Product? product;

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _price;
  late final TextEditingController _description;
  late final TextEditingController _image;
  String? _category;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final product = widget.product;
    _title = TextEditingController(text: product?.title);
    _price = TextEditingController(text: product?.price.toString());
    _description = TextEditingController(text: product?.description);
    _image = TextEditingController(text: product?.image);
    _category = product?.category;
  }

  @override
  void dispose() {
    _title.dispose();
    _price.dispose();
    _description.dispose();
    _image.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _saving = true);
    final previous = widget.product;
    final product = Product(
      id: previous?.id ?? 0,
      title: _title.text.trim(),
      price: double.parse(_price.text),
      description: _description.text.trim(),
      category: _category!,
      image: _image.text.trim(),
      rating: previous?.rating ?? const Rating(),
    );
    try {
      await context.read<ProductProvider>().saveProduct(product, isNew: previous == null);
      if (mounted) Navigator.pop(context, true);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No pudimos guardar el producto. Revisa tu conexi\u00f3n.')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.product == null ? 'Nuevo producto' : 'Editar producto'),
          flexibleSpace: const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFFFFF1F7), Color(0xFFF0E9FF)]),
            ),
          ),
        ),
        body: Stack(children: [
          const Positioned.fill(child: SakuraBackground(opacity: .36)),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 620),
                  child: Form(
                    key: _form,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [Color(0xFFFFDCEC), Color(0xFFE9E0FF)]),
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [BoxShadow(color: AppTheme.pink.withValues(alpha: .2), blurRadius: 18, offset: const Offset(0, 8))],
                        ),
                        child: Column(children: [
                          Align(alignment: Alignment.centerLeft, child: Text(widget.product == null ? 'Un detalle nuevo para tu tienda' : 'Actualiza los detalles', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17, color: AppTheme.ink))),
                          const SizedBox(height: 14),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.easeOutCubic,
                            height: 175,
                            width: double.infinity,
                            decoration: BoxDecoration(color: Colors.white.withValues(alpha: .82), borderRadius: BorderRadius.circular(22), border: Border.all(color: Colors.white, width: 2)),
                            child: _image.text.isEmpty
                                ? const Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.add_photo_alternate_outlined, size: 42, color: AppTheme.lavender), SizedBox(height: 8), Text('Agrega una imagen con su URL', style: TextStyle(color: AppTheme.ink))])
                                : ClipRRect(borderRadius: BorderRadius.circular(20), child: Image.network(_image.text, fit: BoxFit.contain, errorBuilder: (context, error, stack) => const Icon(Icons.broken_image_outlined, size: 42, color: AppTheme.lavender))),
                          ),
                          const SizedBox(height: 8),
                          const Text('Vista previa de la imagen', style: TextStyle(color: AppTheme.ink, fontSize: 12)),
                        ]),
                      ),
                      const SizedBox(height: 18),
                      CustomTextField(controller: _image, label: 'URL de la imagen', icon: Icons.link_rounded, validator: Validators.imageUrl, onChanged: (_) => setState(() {})),
                      const SizedBox(height: 12),
                      CustomTextField(controller: _title, label: 'T\u00edtulo', icon: Icons.title_rounded, validator: Validators.title),
                      const SizedBox(height: 12),
                      CustomTextField(controller: _price, label: 'Precio (ej. 29.99)', icon: Icons.attach_money_rounded, validator: Validators.price, keyboardType: const TextInputType.numberWithOptions(decimal: true)),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        initialValue: _category,
                        decoration: const InputDecoration(labelText: 'Categor\u00eda', prefixIcon: Icon(Icons.category_outlined)),
                        items: kCategories.map((category) => DropdownMenuItem(value: category, child: Text(category))).toList(),
                        onChanged: (value) => setState(() => _category = value),
                        validator: Validators.category,
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(controller: _description, label: 'Descripci\u00f3n', icon: Icons.notes_rounded, validator: Validators.description, maxLines: 4),
                      const SizedBox(height: 20),
                      GradientButton(label: _saving ? 'Guardando...' : 'Guardar producto', icon: Icons.check_rounded, onPressed: _saving ? null : _save),
                      const SizedBox(height: 8),
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar', style: TextStyle(color: AppTheme.lavender, fontWeight: FontWeight.w700))),
                    ]),
                  ),
                ),
              ),
            ),
          ),
        ]),
      );
}
