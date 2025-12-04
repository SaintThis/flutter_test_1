# Flutter Authentication Demo

A Flutter application demonstrating authentication flow with GetX state management and MVC architecture.

## Features

- **Login Screen**: Username/password authentication with DummyJSON API
- **Signup Screen**: User registration form with validation
- **Home/Dashboard**: User info display with logout functionality
- **Session Persistence**: Auto-login using GetStorage
- **Form Validation**: Email format, password strength, matching passwords

## Technology Stack

- **Flutter** 3.x
- **GetX** ^4.6.6 - State management, navigation, dependency injection
- **http** ^1.1.0 - HTTP requests
- **get_storage** ^2.1.1 - Local storage for token persistence

## Project Structure (MVC Pattern)

```
lib/
├── models/           # Data classes
│   ├── user_model.dart
│   └── auth_request_model.dart
├── views/            # UI screens
│   ├── login_view.dart
│   ├── signup_view.dart
│   └── home_view.dart
├── controllers/      # Business logic
│   └── auth_controller.dart
├── services/         # API calls
│   └── api_service.dart
├── routes/           # Navigation
│   └── app_routes.dart
└── main.dart
```

## How to Run

1. Ensure Flutter is installed and configured
2. Clone the repository
3. Run:
   ```bash
   flutter pub get
   flutter run
   ```

## Test Credentials

Using DummyJSON API:
- **Username**: `emilys`
- **Password**: `emilyspass`

## API

- **Login**: POST `https://dummyjson.com/auth/login`
- **Signup**: Simulated locally (no real endpoint)

## Assumptions

1. Signup is simulated since DummyJSON doesn't have a real signup endpoint
2. Using username instead of email for login (DummyJSON requirement)

## Known Issues

None currently.

## Bonus Features Implemented

- Loading indicators during API calls
- Form validation with user feedback
- GetX snackbars for notifications
- Clean MVC architecture
- Token-based session persistence
