# Todo App - Flutter Frontend

A full-stack todo application built with Flutter and Dart Frog backend, following MVVM architecture pattern with Cubit state management.

## Features

- ✅ Create, Read, Update, Delete todos
- ✅ User management (Create users)
- ✅ Priority levels (Low, Medium, High)
- ✅ Status tracking (Todo, In Progress, Done)
- ✅ Real-time state management with Cubit (Flutter Bloc)
- ✅ Clean MVVM architecture
- ✅ Dio for network requests
- ✅ Material Design 3 UI

## Architecture

This app follows the **MVVM (Model-View-ViewModel)** architecture pattern:

### 📁 Project Structure

```
lib/
├── core/
│   ├── constants/
│   │   └── api_constants.dart
│   └── network/
│       ├── dio_client.dart
│       ├── api_response.dart
│       └── network_exception.dart
├── data/
│   ├── models/
│   │   ├── create_todo_dto.dart
│   │   ├── update_todo_dto.dart
│   │   └── create_user_dto.dart
│   └── services/
│       ├── todo_service.dart
│       └── user_service.dart
├── presentation/
│   ├── screens/
│   │   └── home_screen.dart
│   ├── widgets/
│   │   ├── todo_list_widget.dart
│   │   ├── todo_item_widget.dart
│   │   ├── add_todo_dialog.dart
│   │   ├── add_user_dialog.dart
│   │   └── user_selector_widget.dart
│   └── viewmodels/
│       ├── todo_viewmodel.dart
│       └── user_viewmodel.dart
└── main.dart
```

### 🏗️ Architecture Components

- **Models**: Data transfer objects for API communication
- **Services**: Network layer using Dio for HTTP requests
- **Cubits**: State management using Cubit (Flutter Bloc)
- **Views**: UI screens and widgets with BlocBuilder/BlocConsumer
- **Core**: Network configuration and utilities

## Getting Started

### Prerequisites

- Flutter SDK (>=3.8.1)
- Dart SDK
- Backend server running on `http://localhost:8080`

### Installation

1. Navigate to the frontend directory:

   ```bash
   cd packages/frontend
   ```

2. Install dependencies:

   ```bash
   flutter packages get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## API Integration

The app communicates with the Dart Frog backend through these endpoints:

### Todo Endpoints

- `GET /todo` - Get all todos
- `POST /todo` - Create a new todo
- `PUT /todo/{id}` - Update a todo
- `DELETE /todo/{id}` - Delete a todo

### User Endpoints

- `GET /user` - Get all users
- `POST /user` - Create a new user

## State Management

The app uses **Cubit (Flutter Bloc)** for state management:

- `TodoCubit`: Manages todo state and operations
- `UserCubit`: Manages user state and operations
- Reactive UI updates using BlocBuilder/BlocConsumer
- Error handling and loading states
- Immutable state management with Equatable

## Key Features

### Todo Management

- Create todos with title, description, priority, and status
- Edit existing todos
- Delete todos with confirmation
- Toggle todo status (Todo → In Progress → Done)
- Visual priority indicators (Low/Medium/High)

### User Management

- Create users with name and email
- User selection for todo assignment
- Email validation

### UI/UX

- Material Design 3 components
- Responsive design
- Loading states and error handling
- Success/error message notifications
- Intuitive navigation and interactions

## Dependencies

- `flutter_bloc`: State management with Cubit
- `bloc`: Core bloc functionality
- `equatable`: Immutable state comparison
- `dio`: HTTP client for API calls
- `shared`: Shared models and enums from the monorepo

## Development

### Running Tests

```bash
flutter test
```

### Code Analysis

```bash
flutter analyze
```

### Building for Production

```bash
flutter build apk  # Android
flutter build ios  # iOS
```

## Contributing

1. Follow Flutter/Dart best practices
2. Maintain MVVM architecture
3. Write clean, readable code
4. Add proper error handling
5. Test your changes thoroughly

## License

This project is part of a full-stack todo application demonstration.
