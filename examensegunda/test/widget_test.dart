import 'package:flutter_test/flutter_test.dart';
import 'package:sakura_shop/main.dart';

void main() {
  testWidgets('Sakura Shop abre la pantalla de inicio de sesión', (tester) async {
    await tester.pumpWidget(const SakuraShopApp());
    expect(find.text('Sakura Shop'), findsOneWidget);
    expect(find.text('¡Hola de nuevo!'), findsOneWidget);
    expect(find.text('Ingresar'), findsOneWidget);
  });
}
