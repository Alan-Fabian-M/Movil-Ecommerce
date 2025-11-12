# Aplicación Móvil E-Commerce - Tesla Boutique

Esta es la aplicación móvil Flutter para la plataforma de e-commerce Tesla Boutique.

## 🚀 Características Implementadas

- ✅ **Lista de Productos**: Visualización de productos desde la API del backend
- ✅ **Grid Responsive**: Vista de cuadrícula adaptable con 2 columnas
- ✅ **Búsqueda en Tiempo Real**: Filtrado de productos por nombre
- ✅ **Paginación**: Navegación entre páginas de productos
- ✅ **Pull to Refresh**: Actualización de datos deslizando hacia abajo
- ✅ **Imágenes de Productos**: Carga de imágenes desde el servidor con indicador de progreso
- ✅ **Manejo de Errores**: Mensajes de error amigables y opción de reintentar
- ✅ **Detalles de Producto**: Modal con información completa del producto
- ✅ **Interfaz Moderna**: Diseño dark mode con tipografía Google Fonts

## 📋 Requisitos Previos

- Flutter SDK 3.9.0 o superior
- Dart SDK
- Android Studio / Xcode (para desarrollo móvil)
- Backend corriendo en localhost:8000 (o configurar la URL en `api_config.dart`)

## 🔧 Configuración

### 1. Configurar la URL de la API

Edita el archivo `lib/data/config/api_config.dart`:

```dart
class ApiConfig {
  // Para emulador Android: http://10.0.2.2:8000
  // Para dispositivo físico: http://TU_IP_LOCAL:8000
  // Para iOS simulator: http://localhost:8000
  static const String baseUrl = 'http://10.0.2.2:8000';
  
  // ... resto del código
}
```

**Configuraciones comunes:**
- **Emulador Android**: `http://10.0.2.2:8000`
- **iOS Simulator**: `http://localhost:8000`
- **Dispositivo Físico**: `http://192.168.X.X:8000` (tu IP local)

### 2. Instalar Dependencias

```bash
cd mobile
flutter pub get
```

### 3. Verificar que el Backend esté corriendo

Asegúrate de que el backend Django esté corriendo:

```bash
cd backend
python manage.py runserver
```

### 4. Ejecutar la Aplicación

```bash
cd mobile
flutter run
```

## 📱 Estructura del Proyecto

```
mobile/
├── lib/
│   ├── data/
│   │   ├── config/
│   │   │   └── api_config.dart          # Configuración de la API
│   │   ├── models/
│   │   │   ├── product_model.dart       # Modelos de datos
│   │   │   └── cart_model.dart
│   │   └── services/
│   │       └── product_service.dart     # Servicio de API
│   ├── presentation/
│   │   ├── screens/
│   │   │   ├── home_screen.dart         # Pantalla principal
│   │   │   ├── product_detail_screen.dart
│   │   │   └── ...
│   │   └── widgets/
│   │       ├── product_card.dart        # Tarjeta de producto
│   │       └── ...
│   └── main.dart                        # Punto de entrada
└── pubspec.yaml                         # Dependencias
```

## 🎨 Características de la UI

### Home Screen
- Banner hero con gradiente
- Barra de búsqueda funcional
- Grid de productos 2x2
- Paginación inferior
- Pull to refresh

### Product Card
- Imagen del producto con lazy loading
- Nombre del producto
- Categoría
- Botón "Ver detalles"

### Product Detail Modal
- Modal deslizable
- Imagen grande del producto
- Información completa
- Botón "Agregar al Carrito"

## 🔌 API Integration

La aplicación se conecta a los siguientes endpoints:

- **GET** `/api/productos/` - Lista de productos con paginación
  - Parámetros: `page`, `page_size`
  - Respuesta: `{ count, next, previous, results: [] }`

## 🐛 Solución de Problemas

### Error de Conexión

Si ves el error "Error al cargar productos":

1. Verifica que el backend esté corriendo
2. Revisa la configuración de `baseUrl` en `api_config.dart`
3. En emulador Android, usa `10.0.2.2` en lugar de `localhost`
4. En dispositivo físico, usa tu IP local (verifica que estés en la misma red)

### Imágenes no se cargan

- Verifica que las URLs de las imágenes sean accesibles desde el dispositivo
- Revisa los permisos de Internet en `AndroidManifest.xml`

### Errores de Build

```bash
flutter clean
flutter pub get
flutter run
```

## 📝 Próximas Mejoras

- [ ] Implementar autenticación
- [ ] Funcionalidad completa del carrito de compras
- [ ] Gestión de órdenes
- [ ] Perfil de usuario
- [ ] Filtros por categoría
- [ ] Favoritos
- [ ] Notificaciones push

## 🤝 Contribuir

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto es parte del curso SI2 - Universidad Mayor de San Simón
