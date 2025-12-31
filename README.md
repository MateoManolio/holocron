# Holocron - Star Wars Flutter App

![Star Wars](https://img.shields.io/badge/Star%20Wars-Galaxy-yellow)
![Flutter](https://img.shields.io/badge/Flutter-^3.10.3-blue)
![Architecture](https://img.shields.io/badge/Architecture-Clean-green)
![License](https://img.shields.io/badge/License-MIT-purple)


**¡Hola! Esta es mi aplicación desplegada en [Firebase Hosting](https://holocron-6a63d.web.app/)**

> [!IMPORTANT] 
> Para este challenge, quise simular un entorno real de producción. No solo quería que funcionara, sino que fuera mantenible y escalable. Por eso elegí **Clean Architecture** con **BLoC**. Mi objetivo era que, si mañana queremos cambiar la API de Star Wars por otra, o la base de datos local, el impacto en la UI sea nulo.

## 📱 Descripción
Holocron es una aplicación Flutter de vanguardia inspirada en el universo de Star Wars. Diseñada con una estética premium y micro-animaciones fluidas, permite a los usuarios explorar la vasta galaxia de personajes, gestionar favoritos y sincronizar datos en tiempo real entre almacenamiento local (Hive) y la nube (Cloud Firestore).

Este proyecto sirve como una vitrina de mejores prácticas en desarrollo Flutter, implementando Clean Architecture, State Management con BLoC y un sistema de sincronización híbrido robusto.

## 🚀 Características Principales

### 🌌 Exploración Galáctica
- **Búsqueda Inteligente**: Filtrado de personajes en tiempo real con debouncing optimizado.
- **Paginación Infinita**: Sistema "Load More" para navegar por toda la base de datos de SWAPI.
- **Visualización Detallada**: Tarjetas interactivas con efectos de hover y animaciones de escala.

### 🔐 Autenticación y Perfil
- **Firebase Auth**: Soporte para autenticación segura.
- **Modo Invitado**: Acceso limitado para usuarios no autenticados con persistencia local única.
- **Interfaz de Usuario**: Pantallas de Login y Sign-up con diseño inmersivo.

### 💾 Sincronización Híbrida (Hybrid Data Sync)
- **Offline First**: Uso de **Hive (CE)** para persistencia local ultrarrápida.
- **Sincronización en la Nube**: Integración con **Cloud Firestore** para usuarios autenticados.
- **Consistencia de Datos**: Los favoritos se mantienen sincronizados automáticamente cuando se recupera la conexión.

### 🎨 Experiencia de Usuario Premium
- **Fondo de Estrellas Animado**: Un `CustomPainter` optimizado que genera un campo de estrellas en movimiento infinito.
- **Diseño Glassmorphism**: Uso de gradientes, efectos de brillo (glow) y opacidades dinámicas.
- **Micro-animaciones**: Transiciones fluidas en botones, tarjetas y elementos de navegación.

## 🛠️ Stack Tecnológico

- **Core**: Flutter & Dart
- **State Management**: [flutter_bloc](https://pub.dev/packages/flutter_bloc)
- **Dependency Injection**: [get_it](https://pub.dev/packages/get_it)
- **Networking**: [dio](https://pub.dev/packages/dio)
- **Local Database**: [hive_ce](https://pub.dev/packages/hive_ce)
- **Backend/Service**: Firebase (Auth & Firestore)
- **Error Tracking**: [Sentry](https://sentry.io/)
- **Testing**: Mocktail & Bloc Test

## 🏗️ Arquitectura

El proyecto sigue los principios de **Clean Architecture**, dividiendo la aplicación en tres capas principales:

### 1. Domain (Capa de Negocio)
- **Entities**: Modelos de datos puros.
- **Repositories**: Contratos (interfaces) de datos.
- **Use Cases**: Lógica de negocio específica.

### 2. Data (Capa de Infraestructura)
- **Repositories Implementation**: Implementación de los contratos del dominio.
- **DataSources**: Acceso a datos remotos (API) y locales (Database).
- **Models**: DTOs para serialización de datos.

### 3. Presentation (Capa de UI)
- **BLoC**: Lógica de estado y eventos.
- **Pages/Widgets**: Componentes visuales y pantallas.

## 📁 Estructura del Proyecto

```
lib/
├── main.dart
└── src/
    ├── config/             # Configuración de Temas y Rutas
    ├── core/               # Utilidades, Constantes, DI y Servicios base
    ├── data/               # Repos y DataSources (Implementación)
    ├── domain/             # Entidades, Contratos y Casos de Uso
    └── presentation/       # BLoCs y UI Widgets
```

## 🔧 Configuración y Ejecución

### Prerrequisitos
- Flutter SDK (>= 3.10.3)
- Una cuenta de Firebase

### Pasos
1. **Clonar el repositorio**:
   ```bash
   git clone https://github.com/tu-usuario/holocron.git
   cd holocron
   ```

2. **Instalar dependencias**:
   ```bash
   flutter pub get
   ```

3. **Configuración de Firebase**:
   - Sigue las instrucciones detalladas en [FIREBASE_SETUP.md](file:///c:/Users/Mateo/Documents/Aplicaciones/holocron/FIREBASE_SETUP.md).
   - Asegúrate de tener el archivo `.env` configurado.

4. **Ejecutar la app**:
   ```bash
   flutter run
   ```

## 🧪 Testing

El proyecto cuenta con una amplia cobertura de tests (Unitarios y de Widgets).

```bash
# Ejecutar todos los tests
flutter test
```

Los tests se encuentran en el directorio `/test` y siguen la misma estructura que la capa `lib`.

## 📝 Notas de Versión
- **Current Version**: 0.1.0
- **Status**: En desarrollo activo. Las features principales de exploración y favoritos están funcionales.

## 🖼️ Assets y Multimedia

### Personajes
Las imágenes de personajes se encuentran en `assets/people/`. El sistema está preparado para cargar imágenes dinámicamente basadas en el nombre del personaje.

### Fondos y Efectos
- **Hyperspace**: Ubicado en `assets/background/hyperspace.png`, utilizado para efectos de transición y carga.
- **Starfield**: Generado procedimentalmente mediante código para un rendimiento óptimo.

## 🌟 Contribuir
Siéntete libre de abrir issues o enviar pull requests si tienes ideas para mejorar el Holocron.

---
*Que la Fuerza te acompañe.*
