import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/product_provider.dart';
import 'screens/login_screen.dart';
import 'services/auth_service.dart';
import 'services/product_service.dart';
import 'theme/app_theme.dart';

void main() => runApp(const SakuraShopApp());

class SakuraShopApp extends StatelessWidget {
  const SakuraShopApp({super.key});
  @override Widget build(BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider(AuthService())),
          ChangeNotifierProvider(create: (_) => ProductProvider(ProductService())),
        ],
        child: MaterialApp(title: 'Sakura Shop', debugShowCheckedModeBanner: false, theme: AppTheme.light, home: const LoginScreen()),
      );
}
