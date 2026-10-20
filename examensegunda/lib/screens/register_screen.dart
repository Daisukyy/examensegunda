import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import '../utils/validators.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/gradient_button.dart';
import '../widgets/sakura_background.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _form = GlobalKey<FormState>();
  final _user = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() { _user.dispose(); _password.dispose(); super.dispose(); }

  Future<void> _register() async {
    if (!_form.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    if (await auth.register(_user.text, _password.text) && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('\u00a1Cuenta creada! Ya puedes ingresar.')));
      Navigator.pop(context);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(auth.error ?? 'No pudimos crear tu cuenta.')));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Crear cuenta')),
        body: Stack(children: [
          const Positioned.fill(child: SakuraBackground(opacity: .34)),
          Center(child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 480), child: Card(
              color: Colors.white.withValues(alpha: .94),
              elevation: 4,
              shadowColor: AppTheme.pink.withValues(alpha: .18),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              child: Padding(padding: const EdgeInsets.all(24), child: Form(key: _form, child: Column(children: [
                const Icon(Icons.local_florist_rounded, size: 52, color: AppTheme.hotPink),
                const Text('\u00danete a Sakura Shop', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppTheme.ink)),
                const SizedBox(height: 22),
                CustomTextField(controller: _user, label: 'Usuario', icon: Icons.person_outline, validator: Validators.username),
                const SizedBox(height: 14),
                CustomTextField(controller: _password, label: 'Contrase\u00f1a', icon: Icons.lock_outline, validator: Validators.password, obscureText: true),
                const SizedBox(height: 22),
                GradientButton(label: 'Registrarme', icon: Icons.favorite_rounded, onPressed: _register),
              ]))),
            )),
          )),
        ]),
      );
}
