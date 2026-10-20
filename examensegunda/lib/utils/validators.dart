class Validators {
  static String? requiredText(String? value, {String label = 'Este campo'}) => value == null || value.trim().isEmpty ? '$label es obligatorio.' : null;
  static String? username(String? value) => requiredText(value, label: 'El usuario');
  static String? password(String? value) => requiredText(value, label: 'La contraseña');
  static String? title(String? value) { final error = requiredText(value, label: 'El título'); if (error != null) return error; return value!.trim().length < 3 ? 'El título debe tener al menos 3 caracteres.' : null; }
  static String? price(String? value) { final number = double.tryParse(value?.trim() ?? ''); if (number == null) return 'Ingresa un precio numérico válido.'; return number <= 0 ? 'El precio debe ser mayor que 0.' : null; }
  static String? category(String? value) => requiredText(value, label: 'La categoría');
  static String? description(String? value) => requiredText(value, label: 'La descripción');
  static String? imageUrl(String? value) { final uri = Uri.tryParse(value?.trim() ?? ''); if (uri == null || !uri.hasAuthority || !['http', 'https'].contains(uri.scheme)) return 'Ingresa una URL válida que comience con http o https.'; return null; }
}
