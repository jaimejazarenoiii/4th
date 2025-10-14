# 4th - Inventory Tracking App

An elegant Flutter app for organizing and tracking items through a three-level hierarchy: **Spaces → Storages → Items**. Built with **Clean Architecture** and **BLoC** state management.

## Architecture

This app follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── core/                           # Core utilities and shared resources
│   ├── di/
│   │   └── injection_container.dart    # Dependency injection setup
│   ├── error/
│   │   └── failures.dart               # Error handling
│   ├── network/
│   │   ├── api_constants.dart          # API endpoints and config
│   │   ├── dio_client.dart             # HTTP client wrapper
│   │   └── network_info.dart           # Network connectivity check
│   └── usecases/
│       └── usecase.dart                # Base use case
│
├── features/
│   ├── splash/
│   │   └── splash_page.dart            # Splash screen
│   │
│   └── inventory/                      # Main feature module
│       ├── data/                       # Data layer
│       │   ├── datasources/
│       │   │   └── inventory_local_data_source.dart
│       │   ├── models/                 # Data models
│       │   │   ├── item_model.dart
│       │   │   ├── storage_model.dart
│       │   │   └── space_model.dart
│       │   └── repositories/
│       │       └── inventory_repository_impl.dart
│       │
│       ├── domain/                     # Domain layer (business logic)
│       │   ├── entities/               # Business entities
│       │   │   ├── item_entity.dart
│       │   │   ├── storage_entity.dart
│       │   │   └── space_entity.dart
│       │   ├── repositories/           # Repository interfaces
│       │   │   └── inventory_repository.dart
│       │   └── usecases/               # Use cases
│       │       ├── add_space.dart
│       │       ├── delete_space.dart
│       │       ├── get_spaces.dart
│       │       ├── item_usecases.dart
│       │       ├── storage_usecases.dart
│       │       └── update_space.dart
│       │
│       └── presentation/               # Presentation layer
│           ├── bloc/                   # BLoC state management
│           │   ├── inventory_bloc.dart
│           │   ├── inventory_event.dart
│           │   └── inventory_state.dart
│           └── pages/                  # UI screens
│               ├── spaces_page.dart
│               ├── storages_page.dart
│               └── items_page.dart
│
└── main.dart                           # App entry point
```

## Features

### 📦 Three-Level Organization
- **Spaces**: Top-level containers (e.g., "Home", "Office", "Garage")
- **Storages**: Mid-level containers within spaces (e.g., "Closet", "Drawer", "Shelf")
- **Items**: Individual items with details (name, description, quantity)

### 🏛️ Clean Architecture
- **Separation of Concerns**: Clear boundaries between layers
- **Dependency Rule**: Dependencies point inward (domain is independent)
- **Testability**: Easy to unit test business logic
- **Maintainability**: Changes in one layer don't affect others

### 🎯 BLoC Pattern
- **Predictable State Management**: Using flutter_bloc
- **Event-Driven**: User actions trigger events
- **Reactive**: UI automatically updates on state changes
- **Testable**: Easy to test business logic separately

### 💉 Dependency Injection
- **GetIt**: Service locator for dependency injection
- **Lazy Loading**: Dependencies created only when needed
- **Easy Testing**: Mock dependencies for unit tests

### ✨ Full CRUD Operations
- Create, read, update, and delete at all three levels
- Edit any entity with a simple tap and menu selection
- Confirmation dialogs for destructive actions

### 💾 Data Persistence
- Automatic saving to local storage using SharedPreferences
- Data persists across app restarts
- Hierarchical JSON structure for easy data management

### 🎨 Modern UI/UX
- Material Design 3 with a clean, intuitive interface
- **Splash Screen**: Beautiful animated splash screen on app launch
- Color-coded cards for visual hierarchy
- Empty state illustrations with helpful prompts
- Smooth navigation between levels
- Item counts and statistics on each card

## Getting Started

### Prerequisites
- Flutter SDK (3.9.2 or higher)
- Dart SDK
- iOS Simulator/Android Emulator or physical device

### Installation

1. Install dependencies:
```bash
flutter pub get
```

2. Run the app:
```bash
flutter run
```

### For iOS
```bash
cd ios
pod install
cd ..
flutter run
```

### For Android
```bash
flutter run
```

### For Web
```bash
flutter run -d chrome
```

## Dependencies

### State Management & Architecture
- **flutter_bloc**: ^8.1.3 - BLoC pattern implementation
- **equatable**: ^2.0.5 - Value equality for entities
- **get_it**: ^7.6.4 - Dependency injection
- **dartz**: ^0.10.1 - Functional programming (Either type)

### Storage & Utilities
- **shared_preferences**: ^2.2.2 - Local data persistence
- **uuid**: ^4.3.3 - Unique ID generation
- **cupertino_icons**: ^1.0.8 - iOS-style icons

### HTTP Client
- **dio**: ^5.4.0 - HTTP client for API requests
- **pretty_dio_logger**: ^1.3.1 - Beautiful HTTP logging

## Clean Architecture Layers

### 1. Domain Layer (Business Logic)
The core of the application, containing:
- **Entities**: Pure Dart classes representing business objects
- **Repositories**: Abstract interfaces defining data operations
- **Use Cases**: Single-responsibility business logic units

**Key Principle**: No dependencies on external frameworks or libraries.

### 2. Data Layer (Data Management)
Implements the domain layer interfaces:
- **Models**: Extend entities with JSON serialization
- **Data Sources**: Handle actual data operations (SharedPreferences)
- **Repository Implementations**: Connect use cases to data sources

### 3. Presentation Layer (UI)
User interface and state management:
- **BLoC**: Manages UI state and business logic
- **Pages**: UI screens
- **Widgets**: Reusable UI components

## BLoC Pattern

### Events
User actions that trigger state changes:
- `LoadSpacesEvent`
- `AddSpaceEvent`, `UpdateSpaceEvent`, `DeleteSpaceEvent`
- `AddStorageEvent`, `UpdateStorageEvent`, `DeleteStorageEvent`
- `AddItemEvent`, `UpdateItemEvent`, `DeleteItemEvent`

### States
Different states the UI can be in:
- `InventoryInitial` - Initial state
- `InventoryLoading` - Loading data
- `InventoryLoaded` - Data loaded successfully
- `InventoryError` - Error occurred

### Flow
```
User Action → Event → BLoC → Use Case → Repository → Data Source
                ↓
         State Update → UI Rebuilds
```

## Usage

### Creating a Space
1. Tap the **+** button on the Spaces screen
2. Enter a name (required) and optional description
3. Tap **Add**

### Adding Storages
1. Tap on a Space card to view its storages
2. Tap the **+** button
3. Enter storage details
4. Tap **Add**

### Adding Items
1. Navigate to a Storage by tapping its card
2. Tap the **+** button
3. Enter item details:
   - Name (required)
   - Description (optional)
   - Quantity (optional)
4. Tap **Add**

### Editing and Deleting
- Tap the **⋮** menu on any card
- Select **Edit** to modify or **Delete** to remove
- Deletion cascades (deleting a Space removes all its Storages and Items)

## Testing

### Unit Testing
Test use cases and business logic:
```bash
flutter test test/features/inventory/domain/usecases/
```

### Widget Testing
Test UI components:
```bash
flutter test test/features/inventory/presentation/
```

### BLoC Testing
Test BLoC logic:
```bash
flutter test test/features/inventory/presentation/bloc/
```

## Code Quality

### Static Analysis
```bash
flutter analyze
```

### Code Formatting
```bash
flutter format lib/
```

## Technical Details

### State Management
Uses the BLoC pattern with flutter_bloc for reactive state management. The UI automatically rebuilds when the state changes.

### Data Persistence
Data is currently stored as JSON in SharedPreferences for offline-first functionality. The repository pattern abstracts the data source, making it easy to switch between local and remote storage.

### HTTP Client (Dio)
The app includes a configured Dio client ready for API integration:
- **Base URL**: `http://localhost:3000/api/v1/`
- **Automatic logging** in debug mode
- **Error handling** with interceptors
- **Timeout configuration** (30s)
- **Auth token support** for protected endpoints

See `lib/core/network/README.md` for detailed usage instructions.

### Data Models
All entities use Equatable for value equality, which is essential for BLoC state comparison. Models extend entities and add JSON serialization.

### Dependency Injection
GetIt provides a global service locator. Dependencies are registered at app startup and injected where needed.

## Future Enhancements

Potential features for future versions:
- **Search functionality** across all levels
- **Data export/import** (JSON, CSV, cloud backup)
- **Item images and photos**
- **Barcode/QR code scanning**
- **Categories and tags**
- **Dark mode support**
- **Cloud sync** (Firebase/Supabase)
- **Multi-language support**
- **Analytics and insights**
- **Sharing capabilities**
- **Offline-first with sync**

## Design Patterns Used

- **Clean Architecture**: Separation of concerns
- **BLoC Pattern**: State management
- **Repository Pattern**: Data abstraction
- **Dependency Injection**: Loose coupling
- **Use Case Pattern**: Single responsibility
- **Factory Pattern**: Object creation
- **Observer Pattern**: State observation

## License

This project is created as a personal inventory tracking tool.

## Contributing

Contributions are welcome! Please follow these guidelines:
1. Follow Clean Architecture principles
2. Write tests for new features
3. Follow Dart/Flutter style guidelines
4. Update documentation as needed

## Support

For issues, questions, or contributions, please refer to the project repository.

---

Built with ❤️ using Flutter, Clean Architecture, and BLoC
