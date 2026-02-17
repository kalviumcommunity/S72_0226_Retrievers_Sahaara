# Google Sign-In Quick Reference

## Overview

Quick reference guide for using Google Sign-In in the Sahara app.

## Components

### 1. GoogleSignInService
**Location:** `lib/services/google_sign_in_service.dart`

**Singleton Pattern - Just use directly:**
```dart
import 'package:sahara/services/google_sign_in_service.dart';

final googleService = GoogleSignInService();
```

### 2. GoogleSignInButton Widget
**Location:** `lib/widgets/google_sign_in_button.dart`

**Import:**
```dart
import 'package:sahara/widgets/google_sign_in_button.dart';
```

---

## Usage Patterns

### Pattern 1: With AuthProvider (Recommended)

```dart
import 'package:provider/provider.dart';
import 'package:sahara/providers/auth_provider.dart';
import 'package:sahara/widgets/google_sign_in_button.dart';

class MyAuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return GoogleSignInButton(
          onPressed: () async {
            final success = await authProvider.signInWithGoogle(role: 'owner');
            if (success) {
              // Navigate or update UI
              Navigator.pushNamed(context, '/home');
            }
          },
          isLoading: authProvider.isLoading,
        );
      },
    );
  }
}
```

### Pattern 2: Direct Service Usage

```dart
import 'package:sahara/services/google_sign_in_service.dart';

void _signInWithGoogle() async {
  try {
    final googleService = GoogleSignInService();
    
    // Step 1: Sign in with Google UI
    final googleUser = await googleService.signIn();
    if (googleUser == null) {
      print('User cancelled sign-in');
      return;
    }
    
    // Step 2: Authenticate with Firebase
    final firebaseUser = await googleService.authenticateWithFirebase();
    
    // Step 3: Use the authenticated user
    print('Logged in: ${firebaseUser?.displayName}');
    
  } catch (e) {
    print('Error: ${GoogleSignInService.handleError(e)}');
  }
}
```

---

## Button Variants

### Default (Outlined)
```dart
GoogleSignInButton(
  onPressed: _handleSignIn,
  isLoading: isLoading,
)
```

### With Custom Text
```dart
GoogleSignInButton(
  onPressed: _handleSignIn,
  isLoading: isLoading,
  text: 'Sign up with Google',
)
```

### Filled Style
```dart
GoogleSignInButton(
  onPressed: _handleSignIn,
  isLoading: isLoading,
  variant: ButtonVariant.filled,
)
```

### Icon Only (Compact)
```dart
GoogleSignInIconButton(
  onPressed: _handleSignIn,
  isLoading: isLoading,
  size: 48,
)
```

---

## Error Handling

```dart
final authProvider = Provider.of<AuthProvider>(context, listen: false);

try {
  final success = await authProvider.signInWithGoogle(role: 'owner');
  
  if (!success && authProvider.error != null) {
    // Show error to user
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(authProvider.error!),
        backgroundColor: Colors.red,
      ),
    );
  }
} catch (e) {
  print('Unexpected error: $e');
}
```

---

## Complete Example: Login Screen

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sahara/providers/auth_provider.dart';
import 'package:sahara/utils/app_theme.dart';
import 'package:sahara/widgets/google_sign_in_button.dart';

class LoginScreen extends StatefulWidget {
  final String role;

  const LoginScreen({required this.role});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Email and password fields
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 24),

            // Email sign in button
            Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return ElevatedButton(
                  onPressed: authProvider.isLoading ? null : () async {
                    final success = await authProvider.signInWithEmail(
                      email: _emailController.text,
                      password: _passwordController.text,
                    );
                    if (success) {
                      Navigator.pushNamed(context, '/home');
                    }
                  },
                  child: authProvider.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(),
                        )
                      : const Text('Sign In'),
                );
              },
            ),
            const SizedBox(height: 24),

            // Divider
            const Row(
              children: [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('OR'),
                ),
                Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 24),

            // Google sign in button
            Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return GoogleSignInButton(
                  onPressed: () async {
                    final success = await authProvider.signInWithGoogle(
                      role: widget.role,
                    );
                    if (success) {
                      Navigator.pushNamed(context, '/home');
                    }
                  },
                  isLoading: authProvider.isLoading,
                );
              },
            ),

            // Error message
            Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                if (authProvider.error == null) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red[200]!),
                    ),
                    child: Text(
                      authProvider.error!,
                      style: TextStyle(color: Colors.red[700]),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## State Management

### AuthProvider Properties

```dart
// Current user
User? get user

// Loading state
bool get isLoading

// Error message
String? get error

// Is authenticated
bool get isAuthenticated
```

### AuthProvider Methods

```dart
// Sign in with Google
Future<bool> signInWithGoogle({required String role})

// Sign in with email
Future<bool> signInWithEmail({
  required String email,
  required String password,
})

// Sign up with email
Future<bool> signUpWithEmail({
  required String email,
  required String password,
  required String name,
  required String role,
})

// Sign out
Future<void> signOut()

// Clear error
void clearError()
```

---

## Firestore User Document Structure

After Google Sign-In, a user document is created:

```json
{
  "userId": "firebase-uid-here",
  "email": "user@gmail.com",
  "name": "User Name",
  "role": "owner",
  "phone": "",
  "phoneVerified": false,
  "profilePhoto": null,
  "location": null,
  "createdAt": "2026-02-17T10:30:00Z",
  "lastActive": "2026-02-17T10:30:00Z"
}
```

---

## Common Tasks

### Get Current User

```dart
final authProvider = Provider.of<AuthProvider>(context, listen: false);
final user = authProvider.user;
print('Logged in as: ${user?.displayName}');
```

### Check if Authenticated

```dart
final authProvider = Provider.of<AuthProvider>(context, listen: false);
if (authProvider.isAuthenticated) {
  // User is logged in
}
```

### Sign Out

```dart
final authProvider = Provider.of<AuthProvider>(context, listen: false);
await authProvider.signOut();
Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
```

### Handle Authentication State

```dart
StreamBuilder<User?>(
  stream: FirebaseAuth.instance.authStateChanges(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (!snapshot.hasData) {
      return LoginScreen();
    }
    
    return HomeScreen();
  },
)
```

---

## Best Practices

1. **Always use Consumer with AuthProvider**
   ```dart
   Consumer<AuthProvider>(
     builder: (context, authProvider, child) {
       // Access authProvider.isLoading and authProvider.error
     },
   )
   ```

2. **Handle loading states**
   ```dart
   disabled: authProvider.isLoading
   ```

3. **Show error messages**
   ```dart
   if (authProvider.error != null) {
     // Show error
   }
   ```

4. **Clear errors when appropriate**
   ```dart
   authProvider.clearError()
   ```

5. **Use proper navigation**
   ```dart
   Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false)
   ```

---

## Testing

### Mock AuthProvider for Tests

```dart
class MockAuthProvider extends Mock implements AuthProvider {}

testWidgets('GoogleSignInButton works', (WidgetTester tester) async {
  final mockAuth = MockAuthProvider();
  when(mockAuth.isLoading).thenReturn(false);
  
  await tester.pumpWidget(
    ChangeNotifierProvider<AuthProvider>.value(
      value: mockAuth,
      child: const MyAuthScreen(),
    ),
  );
  
  expect(find.byType(GoogleSignInButton), findsOneWidget);
});
```

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Button not working | Check Firebase setup and Client ID |
| User cancelled | Normal behavior, show retry option |
| Auth fails silently | Check error with `authProvider.error` |
| Icon not showing | Place `google.png` in `assets/icons/` |
| Platform specific error | Check Android/iOS config files |

---

## Additional Resources

- 📖 [Complete Integration Guide](GOOGLE_SIGNIN_INTEGRATION_GUIDE.md)
- 🤖 [Android Configuration](ANDROID_GOOGLE_SIGNIN_CONFIG.md)
- 🍎 [iOS Configuration](IOS_GOOGLE_SIGNIN_CONFIG.md)
- 📝 [Implementation Summary](GOOGLE_SIGNIN_IMPLEMENTATION_SUMMARY.md)

---

**Last Updated:** February 17, 2026
