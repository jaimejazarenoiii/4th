# Clean Architecture Diagram - 4th App

## Layer Overview

```
┌─────────────────────────────────────────────────────────────┐
│                     PRESENTATION LAYER                       │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │  Pages (UI)  │  │     BLoC     │  │   Widgets    │      │
│  │              │  │              │  │              │      │
│  │ spaces_page  │←→│inventory_bloc│  │   (Reusable  │      │
│  │storages_page │  │inventory_evt │  │  Components) │      │
│  │  items_page  │  │inventory_st8 │  │              │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└────────────────────────────┬────────────────────────────────┘
                             │ Events/States
                             ↓
┌─────────────────────────────────────────────────────────────┐
│                      DOMAIN LAYER                            │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │   Entities   │  │  Use Cases   │  │ Repository   │      │
│  │   (Pure)     │  │  (Business   │  │  Interfaces  │      │
│  │              │  │    Logic)    │  │              │      │
│  │ SpaceEntity  │  │  GetSpaces   │  │  Inventory   │      │
│  │StorageEntity │  │  AddSpace    │  │  Repository  │      │
│  │  ItemEntity  │  │UpdateSpace   │  │              │      │
│  │              │  │ DeleteSpace  │  │              │      │
│  │              │  │ + Storage &  │  │              │      │
│  │              │  │ Item UseCases│  │              │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└────────────────────────────┬────────────────────────────────┘
                             │ Implements
                             ↓
┌─────────────────────────────────────────────────────────────┐
│                       DATA LAYER                             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │    Models    │  │  Repository  │  │ Data Sources │      │
│  │  (Entities   │  │Implementation│  │              │      │
│  │ + toJson())  │  │              │  │    Local     │      │
│  │              │  │  Inventory   │  │ SharedPrefs  │      │
│  │ SpaceModel   │←→│ Repository   │←→│              │      │
│  │StorageModel  │  │     Impl     │  │              │      │
│  │  ItemModel   │  │              │  │              │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└─────────────────────────────────────────────────────────────┘
                             ↓
                    ┌─────────────────┐
                    │ SharedPreferences│
                    │   (JSON data)   │
                    └─────────────────┘
```

## Data Flow

### Creating a Space (Example)

```
1. User taps "Add" button
        ↓
2. UI dispatches AddSpaceEvent
        ↓
3. BLoC receives event
        ↓
4. BLoC calls AddSpace use case
        ↓
5. Use case calls repository interface
        ↓
6. Repository implementation calls data source
        ↓
7. Data source saves to SharedPreferences
        ↓
8. Success/Failure returned through chain
        ↓
9. BLoC emits new state (InventoryLoaded)
        ↓
10. UI rebuilds automatically
```

## Dependency Flow

```
main.dart
    ↓
Dependency Injection (GetIt)
    ↓
┌───────────────────────────────────┐
│   Register Dependencies           │
│                                   │
│  1. External (SharedPreferences)  │
│  2. Data Sources                  │
│  3. Repositories                  │
│  4. Use Cases                     │
│  5. BLoCs                         │
└───────────────────────────────────┘
    ↓
BlocProvider wraps app
    ↓
SplashPage (initial route)
    ↓
SpacesPage (main screen)
```

## BLoC Flow

```
┌──────────────┐
│     UI       │
│  (Widget)    │
└──────┬───────┘
       │ User Action
       ↓
┌──────────────┐
│    Event     │
│ (User Intent)│
└──────┬───────┘
       │
       ↓
┌──────────────┐
│     BLoC     │
│  (Business   │
│    Logic)    │
└──────┬───────┘
       │
       ↓
┌──────────────┐
│  Use Case    │
│ (Domain Logic)│
└──────┬───────┘
       │
       ↓
┌──────────────┐
│  Repository  │
│ (Data Access)│
└──────┬───────┘
       │
       ↓
┌──────────────┐
│ Data Source  │
│  (Storage)   │
└──────┬───────┘
       │
       ↓ Result
┌──────────────┐
│    State     │
│   (New UI    │
│    State)    │
└──────┬───────┘
       │
       ↓
┌──────────────┐
│      UI      │
│  (Rebuilds)  │
└──────────────┘
```

## Key Principles

### 1. Dependency Rule
- **Outer layers depend on inner layers**
- Domain layer has NO dependencies on external frameworks
- Data layer depends on Domain
- Presentation depends on Domain

### 2. Single Responsibility
- Each class has ONE reason to change
- Use cases do ONE thing
- BLoCs handle ONE feature

### 3. Testability
```
Domain Layer → Easy to test (no dependencies)
Data Layer   → Mock repositories
Presentation → Mock BLoCs, test widgets
```

### 4. Separation of Concerns
```
Presentation → How data is displayed
Domain       → What the data means
Data         → Where data comes from
```

## Module Breakdown

### Core Module
```
core/
├── di/                    # Dependency injection
├── error/                 # Error handling
└── usecases/             # Base use case interface
```

### Feature Module (Inventory)
```
features/inventory/
├── data/
│   ├── datasources/      # Local storage implementation
│   ├── models/           # Data models with JSON
│   └── repositories/     # Repository implementations
│
├── domain/
│   ├── entities/         # Pure business objects
│   ├── repositories/     # Repository contracts
│   └── usecases/        # Business logic
│
└── presentation/
    ├── bloc/            # State management
    └── pages/           # UI screens
```

## Benefits of This Architecture

1. **Testability**: Each layer can be tested independently
2. **Maintainability**: Changes isolated to specific layers
3. **Scalability**: Easy to add new features
4. **Flexibility**: Easy to swap implementations
5. **Reusability**: Domain logic can be reused
6. **Team Collaboration**: Teams can work on different layers
7. **Clear Structure**: New developers understand quickly

## Common Patterns Used

1. **Repository Pattern**: Abstract data access
2. **Use Case Pattern**: Single-purpose business logic
3. **BLoC Pattern**: Predictable state management
4. **Dependency Injection**: Loose coupling
5. **Factory Pattern**: Object creation (Models)
6. **Observer Pattern**: State updates (BLoC)

## Error Handling

```
Data Layer Error
        ↓
Repository catches & converts to Failure
        ↓
Use Case returns Either<Failure, Success>
        ↓
BLoC handles Failure
        ↓
Emits InventoryError state
        ↓
UI shows error message
```

## State Management Flow

```
Initial State: InventoryInitial
        ↓
LoadSpacesEvent triggered
        ↓
State: InventoryLoading (show spinner)
        ↓
Data loaded successfully
        ↓
State: InventoryLoaded (show list)
        ↓
OR Error occurred
        ↓
State: InventoryError (show error)
```

## Future Improvements

- Add analytics layer
- Implement remote data source
- Add caching strategy
- Implement pagination
- Add search functionality
- Multi-language support

---

This architecture ensures the app is:
- **Maintainable**: Easy to update
- **Testable**: Easy to verify
- **Scalable**: Easy to grow
- **Clean**: Easy to understand

