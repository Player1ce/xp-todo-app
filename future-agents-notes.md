# XP Todo App - Future Agents Notes

## Project Overview

**XP Todo App** is a cross-platform Flutter/Dart application for gamified task management. It combines todo tracking with game progression mechanics (quests, game state, profiles). The app uses Firebase for backend services and Riverpod for state management.

**Platform Support**: Android, iOS, Web, Windows, macOS, Linux

---

## Architecture & Design Patterns

### Architectural Pattern: Modular Layered Architecture

The project follows a **modular, layered approach**:

- **Presentation Layer** (`lib/screens/`, `lib/widgets/`): UI screens and reusable widget components
- **State Management Layer** (`lib/providers/`): Riverpod providers for reactive state management
- **Data Layer** (`lib/data/repositories/`, `lib/data/models/`): Data access abstraction and models
- **Utilities & Constants** (`lib/util/`, `lib/const/`): Shared helpers and configuration

### Design Patterns in Use

1. **Dependency Injection via Riverpod**
   - All major services (repositories, Firebase, routing) exposed as providers
   - Providers use code generation (`@Riverpod` annotation)
   - Generated files: `*.g.dart` (excluded from analysis)

2. **Repository Pattern**
   - Interface-based repositories (`i_firestore_repository.dart`)
   - Implementations: `FirestoreRepository`, `GameRepository`, `QuestRepository`, `UserProfileRepository`
   - Abstracts Firestore operations from business logic

3. **Provider Architecture with Riverpod**
   - `auth_providers`: Authentication state (user session, ID token)
   - `firebase_providers`: Firebase service instances
   - `game_providers`: Game state and progression
   - `quest_providers`: Quest logic and queries
   - `repository_providers`: Instantiated repository services
   - `go_router_provider`: Navigation routing

---

## Folder Structure & Responsibilities

```
lib/
├── const/                    # Application constants
│   ├── page_view_configurations.dart
│   └── route_constants.dart
├── data/                     # Data access layer
│   ├── models/              # Entity models
│   └── repositories/        # Firestore abstraction
├── exceptions/              # Custom exception types
├── firebase_options.dart    # Firebase configuration (platform-specific)
├── main.dart               # App entry point
├── notes/                  # (Consolidated to future-agents-notes.md)
├── providers/              # Riverpod state management (code-gen)
├── questlog_design_*.html  # Design reference documents
├── routing/                # Navigation configuration
├── screens/                # Full-page UI screens
├── theme/                  # Material & Cupertino themes
├── todo_notes/             # (Consolidated to future-agents-notes.md)
├── util/                   # Utilities
└── widgets/                # Reusable widget components
```

---

## Key Technical Decisions

### 1. State Management: Riverpod

**Decision**: Use `flutter_riverpod` + `riverpod_annotation` with code generation.

**Rationale**:
- Provides compile-time dependency injection
- Type-safe provider definitions
- Automatic code generation via `build_runner`
- Reactive state updates through provider watching
- Better than Provider or BLoC for this project's scope

**Implementation**:
- All providers in `lib/providers/` use `@Riverpod` annotation
- Generated files (`.g.dart`) excluded from linting
- Providers kept alive where needed for app state (e.g., `@Riverpod(keepAlive: true)`)

### 2. Backend: Firebase + Firestore

**Services Used**:
- `firebase_core`: App initialization
- `firebase_auth`: User authentication (email/password + third-party)
- `cloud_firestore`: Document database (todos, quests, user profiles)
- `cloud_functions`: Server-side logic (if needed)
- `firebase_ui_auth`: Pre-built auth UI components

**Firestore Structure**: TBD in detail, but inferred collections include users, games, quests, and todos.

### 3. Navigation: GoRouter

**Decision**: Use `go_router` (v17.1.0+) for declarative navigation.

**Rationale**:
- URL-based routing (web-friendly, deep linking support)
- Type-safe route definitions
- Works across all platforms
- Integrates with Riverpod for auth-based routing

**Location**: `lib/providers/go_router_provider.dart`

### 4. Platform UI: Adaptive Widgets

**Decision**: Use `adaptive_platform_ui` for Material (Android/Web) and Cupertino (iOS/macOS) designs.

**Rationale**:
- Single UI codebase renders platform-specific components
- Material on Android/Web, Cupertino on iOS/macOS
- Respects native UX conventions

**Theme Configuration**:
- Material themes: `AppMaterialTheme.light/dark`
- Cupertino themes: `AppCupertinoTheme.light/dark`
- Configured in `lib/theme/app_theme.dart`

### 5. Testing Framework: Dart `test` Package (To Be Implemented)

**Recommendation**: Use Dart's native `test` package + `integration_test`.

**Structure**:
- `test/unit/` — Unit tests for business logic
- `test/widget/` — Widget tests for UI components
- `test/integration/` — Integration tests for workflows

**Current Status**: Only `test/widget_test.dart` exists (needs expansion).

---

## Code Quality Standards

### Linting & Analysis

- **Tool**: `flutter_lints` (package:flutter_lints/flutter.yaml)
- **Enhanced**: `riverpod_lint` v3.1.3 for provider analysis
- **Excluded**: `**/*.g.dart`, `**/*.freezed.dart`, `build/` directory
- **Run**: `flutter analyze`

### Documentation Requirements (Per Code Guidelines)

- Document public functions, classes, and non-obvious logic
- Use Dart doc comments (`/// ...`)
- Include parameter types, return types, and error cases
- Skip documentation for trivial getters or self-evident code

### Naming Conventions

- Follow Dart conventions: `lowerCamelCase` for variables/functions, `UpperCamelCase` for classes
- Constants: `UPPER_SNAKE_CASE` or `lowerCamelCase` (Dart convention: `lowerCamelCase`)
- Private methods/fields: prefix with `_`
- Provider names: descriptive, e.g., `activeUserIdProvider`, `requiredAuthStateProvider`

---

## Current Known Issues & TODOs

### Code Quality

1. **Error Handling** (Priority: HIGH)
   - Firebase initialization in `main.dart` has commented-out error handling (lines 16–32)
   - TODO comment: implement top-level error catching with nice error screen (line 39)
   - **Action**: Uncomment or implement promised error handling

2. **Dead Code**
   - Commented Firebase initialization block in `main.dart`
   - **Action**: Clean up or complete implementation

3. **ID Token Claims Updates** (Priority: LOW)
   - TODO in `auth_providers.dart` (line 34–36): Consider propagating claims updates via `rolesUpdatesAt` field
   - **Current Status**: Not necessary for MVP; defer to future optimization

### Testing

- **Status**: Only placeholder `test/widget_test.dart` exists
- **Action**: Implement comprehensive unit and widget tests following test structure guidelines
- **Priority**: HIGH—required per code guidelines

### Documentation

- **Status**: Minimal READMEs, no future-agents-notes before this file
- **Action**: Complete this file (done), then document public APIs

---

## Firebase Configuration

- **Configuration File**: `lib/firebase_options.dart` (platform-specific, auto-generated or manually maintained)
- **Initialization**: `main.dart` → `Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)`
- **Firestore Caching**: Configured via `lib/util/configure_firestore_cache.dart`

---

## Dependencies Overview

### Core Framework

- `flutter`: UI framework
- `flutter_localizations`: i18n support (locales: likely en, etc.)

### State Management & Reactive

- `flutter_riverpod` (3.2.1): State management
- `riverpod_annotation` (4.0.2): Provider annotations
- `build_runner`: Code generation for Riverpod

### Backend & Firebase

- `firebase_core` (4.5.0)
- `firebase_auth` (6.2.0)
- `cloud_firestore` (6.1.3)
- `firebase_ui_auth` (3.0.1)
- `cloud_functions` (6.0.7)

### Navigation & Routing

- `go_router` (17.1.0): URL-based navigation

### UI & Platform Adaptation

- `adaptive_platform_ui` (0.1.103): Platform-aware widgets
- `google_fonts` (8.0.2): Custom fonts
- `cupertino_icons` (1.0.8): iOS icons
- `intl` (0.20.2): Internationalization utilities

### Utilities

- `collection` (1.19.1): Extended collections
- `csv` (8.0.0): CSV parsing/export
- `file_saver` (0.3.1): File download/save
- `universal_html` (2.3.0): Cross-platform HTML utilities

---

## Development Workflow

### Building & Running

```bash
# Web
flutter run -d chrome

# Android
flutter run -d android-emulator

# iOS
flutter run -d ios-simulator

# Desktop (Windows/macOS/Linux)
flutter run -d windows  # or macos / linux
```

### Code Generation

```bash
# Watch for changes and regenerate
flutter pub run build_runner watch

# One-time build
flutter pub run build_runner build
```

### Linting & Analysis

```bash
flutter analyze
```

---

## Consolidated Notes

### Original `notes/` & `todo_notes/` Directories

These directories were empty but reserved for session-specific notes. All future agent guidance is now centralized in this file. Team members should update this file when making architectural or structural decisions.

---

## For Future Agents

When making changes:

1. **Update this file** if you make architectural decisions, add new layers, or change testing/CI approaches
2. **Follow the code guidelines** in `.github/instructions/user-code-guidelines.instructions.md`
3. **Maintain Riverpod patterns** when adding providers; use code generation consistently
4. **Test everything**: Add unit, widget, or integration tests alongside feature work
5. **Document public APIs**: Use Dart doc comments for all public classes and methods
6. **Keep Firestore design in mind**: Ensure repository layer abstractions remain clean as data models evolve

---

**Last Updated**: 2026-05-16  
**Current Version**: 1.0.0+1
