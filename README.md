# Holocron - Star Wars Flutter App

## 📱 Descripción
Aplicación Flutter inspirada en Star Wars con un diseño moderno y elegante para explorar personajes de la galaxia.

## 🎨 Características de Diseño

### Tema Star Wars
- **Paleta de colores**: Colores oscuros espaciales con amarillo imperial y azul holográfico
- **Animaciones**: Micro-animaciones en todos los componentes interactivos
- **Efectos visuales**: Fondo animado de estrellas en movimiento

### Componentes Implementados

#### 1. **HolocronAppBar**
- Header personalizado con logo animado
- Opciones de navegación: CHARACTERS y FAVORITES
- Botón de perfil con efectos hover
- Sistema modular para agregar más opciones en el futuro

#### 2. **HeroSection**
- Título grande "Explore the Galaxy"
- Subtítulo descriptivo
- Campo de búsqueda con animaciones de foco
- Ícono de filtros (tune)

#### 3. **ResultsHeader**
- Muestra cantidad de resultados ("Showing X results")
- Selector de ordenamiento (Sort by)
- Diseño responsivo

#### 4. **CharacterCard**
- Tarjetas de personajes con imágenes
- Botón de favoritos con ícono de corazón
- Animaciones hover y efectos de escala
- Gradientes en el fondo del nombre

#### 5. **LoadMoreButton**
- Botón estilizado para cargar más contenido
- Estados: normal, hover y loading
- Animaciones de escala al interactuar
- Ícono de refresh animado

#### 6. **AppFooter**
- Logo y nombre de la app
- Descripción breve
- Links de navegación (About, Privacy, etc.)
- Copyright y atribución de Star Wars
- Diseño con gradientes y dividers

## 📁 Estructura del Proyecto

```
lib/
├── main.dart
└── src/
    ├── config/
    │   └── theme/
    │       └── app_theme.dart              # Tema Star Wars
    ├── presentation/
    │   ├── pages/
    │   │   └── home/
    │   │       ├── home_page.dart          # Página principal
    │   │       └── widgets/
    │   │           ├── holocron_app_bar.dart
    │   │           ├── app_bar_options.dart
    │   │           ├── profile_button.dart
    │   │           ├── hero_section.dart
    │   │           ├── search_input.dart
    │   │           ├── results_header.dart
    │   │           ├── character_card.dart
    │   │           ├── load_more_button.dart
    │   │           └── app_footer.dart
    │   └── widgets/
    │       ├── starfield_background.dart   # Fondo animado
    │       └── widgets.dart                # Barrel file
    ├── domain/
    └── data/

assets/
└── people/                                 # Imágenes de personajes
    ├── c3po.png
    ├── chewby.png
    ├── kenobi.png
    ├── leia.png
    ├── luke.png
    ├── r2d2.png
    ├── solo.png
    └── vader.png
```

## 🎯 Mejores Prácticas Implementadas

### 1. Modularización Extrema
- Cada widget en su propio archivo
- Un widget público por archivo
- Widgets privados (`_WidgetName`) solo para componentes internos pequeños
- Separación clara de responsabilidades

### 2. Animaciones
- `TweenAnimationBuilder` para animaciones de entrada
- `AnimationController` para animaciones continuas (fondo de estrellas)
- `ScaleTransition` en botones y tarjetas
- Efectos hover con `MouseRegion`
- Animaciones de presión con `GestureDetector`

### 3. Diseño Star Wars
- Gradientes en todos los elementos
- Glow effects con `BoxShadow`
- Colores temáticos consistentes
- Tipografía con spacing amplio (letterSpacing)
- Uso de `withValues(alpha:)` para opacidad en Flutter 3.10+

### 4. Performance
- Constructores `const` donde es posible
- `RepaintBoundary` implícito en CustomPainter
- Animaciones optimizadas con curves
- `SingleTickerProviderStateMixin` para animaciones eficientes
- GridView con `physics: NeverScrollableScrollPhysics()` dentro de ScrollView

### 5. Código Limpio
- Nombres descriptivos
- Comentarios explicativos
- Separación de datos mock del UI
- Preparado para implementar state management

## 🚀 Componentes por Implementar

### Lógica (próximos pasos):
1. **State Management**: Implementar provider, riverpod o bloc
2. **Búsqueda real**: Conectar input con filtrado de personajes
3. **Favoritos**: Implementar sistema de favoritos persistente
4. **Sorting**: Implementar diferentes opciones de ordenamiento
5. **Paginación**: Implementar carga dinámica con Load More
6. **Navegación**: Routing a páginas de detalle de personajes

## 🎨 Customización

### Cambiar colores
Edita `lib/src/config/theme/app_theme.dart`:
```dart
static const Color spaceBlack = Color(0xFF0A0E27);
static const Color imperialYellow = Color(0xFFFFE81F);
static const Color holoBlue = Color(0xFF4DA6FF);
```

### Ajustar animaciones
Modifica las duraciones en cada widget:
```dart
duration: const Duration(milliseconds: 600),
```

### Agregar más opciones al AppBar
Edita `app_bar_options.dart`:
```dart
final List<String> _options = ['CHARACTERS', 'FAVORITES', 'NEW_OPTION'];
```

## 🖼️ Assets

Las imágenes de personajes están en `assets/people/`:
- Luke Skywalker
- Darth Vader
- Princess Leia
- C-3PO
- Obi-Wan Kenobi
- Chewbacca
- Han Solo
- R2-D2

Para agregar más personajes, solo añade la imagen en la carpeta y actualiza el array en `home_page.dart`.

## 📝 Notas Técnicas

- **Flutter Version**: 3.10.3+
- **Material Design**: 3
- **Estado actual**: Solo UI, sin lógica de negocio
- **Responsive**: Diseñado para desktop/tablet (4 columnas en grid)
- **Assets**: Configurados en `pubspec.yaml`

## 🌟 Características Destacadas

- ✅ Fondo animado de estrellas en movimiento continuo
- ✅ Gradientes personalizados en todos los componentes
- ✅ Sistema de colores completamente temático
- ✅ Animaciones fluidas en cada interacción
- ✅ Modularización extrema para fácil mantenimiento
- ✅ Preparado para escalar con state management
- ✅ Sin lógica implementada - solo visual

## 🔧 Cómo Ejecutar

```bash
# Obtener dependencias
flutter pub get

# Ejecutar en dispositivo/emulador
flutter run

# Ejecutar en web
flutter run -d chrome

# Ejecutar en Windows
flutter run -d windows
```
