# Sakura Shop

Aplicación Flutter multiplataforma para consultar y administrar productos de [FakeStoreAPI](https://fakestoreapi.com/products/), con una interfaz kawaii pastel y estado administrado con Provider.

## Requisitos y ejecución

- Flutter compatible con Dart `^3.13.5`.
- Conexión a Internet para cargar productos y enviar cambios a FakeStoreAPI.

```bash
flutter pub get
flutter run
```

Usuario de demostración: `daira`  
Contraseña: `123456`

Las cuentas creadas durante el registro se conservan en memoria mientras la app está abierta; se pierden al reiniciarla.

## Funciones

- Inicio de sesión y registro en memoria, con validación de campos obligatorios.
- Lista con búsqueda por título, filtros combinables por categoría, actualización por gesto y estado vacío/error.
- Vista de detalle, favorito visual, formulario compartido para alta/edición y confirmación al eliminar.
- Validación de título, precio, categoría, descripción y URL de imagen.
- Diseño adaptable con Material 3, Poppins y transiciones Hero en imágenes.

FakeStoreAPI confirma las operaciones POST, PUT y DELETE, pero no guarda los cambios. Después de una respuesta exitosa, `ProductProvider` modifica la lista local en memoria para que la interfaz muestre el resultado. Al reiniciar o volver a cargar desde el servidor, FakeStoreAPI devuelve sus datos originales.

## Estructura de `lib/`

```text
lib/
├── main.dart
├── models/       # Product, Rating y User
├── providers/    # ProductProvider y AuthProvider
├── screens/      # Login, registro, productos, detalle y formulario
├── services/     # Peticiones HTTP y autenticación
├── theme/        # Tema visual
├── utils/        # Constantes y validadores
└── widgets/      # Componentes reutilizables
```

## Preguntas de comprensión

### ¿Cuál es el código generado para el Future?

`Future<T>` representa un resultado que estará disponible después: `T` es el tipo del valor. Por ejemplo, `ProductService.getProducts()` devuelve `Future<List<Product>>`; en el código se transforma la respuesta JSON en una lista de productos. `Future<void>` indica una operación asíncrona que no devuelve un valor, como `ProductProvider.loadProducts()`.

### ¿Para qué sirve async y qué hace await?

`async` marca una función asíncrona y permite que retorne un `Future`. `await` espera el resultado de otro `Future` sin bloquear la interfaz. Por ejemplo, el servicio espera la respuesta HTTP y el provider después espera la lista para actualizar el estado.

### ¿Nombre de los modelos creados?

`Product`, `Rating` (incluida en el archivo del producto) y `User`. `Product` y `Rating` tienen conversiones `fromJson` y `toJson`.

### ¿Qué sucede si no hay conexión a Internet?

La excepción de conexión se captura en `ProductProvider`. La pantalla muestra un mensaje amable y el botón **Reintentar**; la app permanece abierta. Si falla POST/PUT/DELETE se muestra un SnackBar y no se aplica el cambio local.

### Lista de las carpetas dentro de `lib/`

`models/`, `providers/`, `screens/`, `services/`, `theme/`, `utils/` y `widgets/`. `main.dart` está en la raíz de `lib/`.
