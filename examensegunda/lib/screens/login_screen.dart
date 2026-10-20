import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import '../utils/validators.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/gradient_button.dart';
import '../widgets/sakura_background.dart';
import 'products_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final _user = TextEditingController();
  final _password = TextEditingController();
  bool _hide = true;

  @override
  void dispose() {
    _user.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_form.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    if (await auth.login(_user.text, _password.text) && mounted) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const ProductsScreen()));
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(auth.error ?? 'No se pudo iniciar sesi\u00f3n.')));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Stack(children: [
          const Positioned.fill(child: SakuraBackground(opacity: .32)),
          SafeArea(
            child: LayoutBuilder(builder: (context, box) => SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: box.maxHeight),
                child: Center(child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Column(children: [
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                      padding: const EdgeInsets.fromLTRB(24, 22, 24, 30),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFFFFADD0), Color(0xFFD7C4FF)]),
                        borderRadius: BorderRadius.circular(38),
                        boxShadow: [BoxShadow(color: AppTheme.pink.withValues(alpha: .3), blurRadius: 24, offset: const Offset(0, 12))],
                      ),
                      child: Column(children: [
                        Align(alignment: Alignment.centerLeft, child: Text('9:41   \u25c9', style: TextStyle(color: AppTheme.ink.withValues(alpha: .8)))),
                        const SizedBox(height: 16),
                        Container(
                          width: 116,
                          height: 116,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white, border: Border.all(color: AppTheme.hotPink, width: 4), boxShadow: [BoxShadow(color: AppTheme.hotPink.withValues(alpha: .18), blurRadius: 16)]),
                          child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.local_florist_rounded, color: AppTheme.hotPink, size: 33), Icon(Icons.sentiment_satisfied_alt_rounded, color: AppTheme.ink, size: 36)]),
                        ),
                        const SizedBox(height: 12),
                        const Text('Sakura Shop', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white)),
                        const Text('tu tiendita kawaii favorita', style: TextStyle(color: Colors.white)),
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 28, 24, 18),
                      child: Form(key: _form, child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                        const Text('\u00a1Hola de nuevo!', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 23, color: AppTheme.ink)),
                        const Text('Inicia sesi\u00f3n para continuar', style: TextStyle(color: Color(0xFF927FA0))),
                        const SizedBox(height: 18),
                        CustomTextField(controller: _user, label: 'Usuario', icon: Icons.person_outline_rounded, validator: Validators.username),
                        const SizedBox(height: 12),
                        CustomTextField(controller: _password, label: 'Contrase\u00f1a', icon: Icons.lock_outline_rounded, validator: Validators.password, obscureText: _hide, suffixIcon: IconButton(onPressed: () => setState(() => _hide = !_hide), icon: Icon(_hide ? Icons.visibility_outlined : Icons.visibility_off_outlined))),
                        const SizedBox(height: 18),
                        Consumer<AuthProvider>(builder: (context, auth, _) => GradientButton(label: auth.isLoading ? 'Ingresando...' : 'Ingresar', icon: Icons.favorite_rounded, onPressed: auth.isLoading ? null : _login)),
                        Center(child: TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())), child: const Text('\u00bfNo tienes cuenta? Reg\u00edstrate', style: TextStyle(color: AppTheme.hotPink, fontWeight: FontWeight.w600)))),
                      ])),
                    ),
                  ]),
                )),
              ),
            )),
          ),
        ]),
      );
}
