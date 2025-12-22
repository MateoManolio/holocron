# Firebase Authentication Setup Instructions

This guide will help you configure Firebase for the Holocron web application.

## Prerequisites

- Flutter installed on your system
- A Google/Firebase account
- `flutterfire` CLI installed globally

## Step 1: Install FlutterFire CLI

If you haven't installed the FlutterFire CLI yet, run:

```bash
dart pub global activate flutterfire_cli
```

## Step 2: Create a Firebase Project

1. Go to the [Firebase Console](https://console.firebase.google.com/)
2. Click "Add Project" or "Create a project"
3. Enter a project name (e.g., "Holocron")
4. Follow the prompts to complete project creation

## Step 3: Configure FlutterFire

Run the following command in your project root:

```bash
flutterfire configure
```

This will:
- Connect to your Firebase account
- Ask you to select your Firebase project
- Ask which platforms you want to support (select **Web** only)
- Generate `lib/firebase_options.dart` with your actual Firebase configuration

**Important**: Make sure to select **Web** when asked about platforms!

## Step 4: Enable Authentication Methods

In the Firebase Console:

1. Go to **Build** → **Authentication**
2. Click **Get Started**
3. Enable **Email/Password** sign-in method
4. Enable **Anonymous** sign-in method (for guest users)

## Step 5: Update Security Rules (Optional)

If you plan to use Firestore or Storage in the future, configure security rules to check for authenticated users:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

## Step 6: Run the Application

```bash
flutter run -d edge
# or
flutter run -d chrome
```

## Testing the Authentication

1. **Login Page**: You should see a login screen when the app starts
2. **Guest Access**: Click "Continue as Guest" to use anonymous authentication
3. **Profile Button**: In the top-right corner, you'll see:
   - A blue icon for authenticated users
   - A yellow icon for guest users
4. **Logout**: Click the profile button and select "Logout"

## Troubleshooting

### "DefaultFirebaseOptions have not been configured for web"

This means you haven't run `flutterfire configure` yet or didn't select Web as a platform.

**Solution**: Run `flutterfire configure` again and make sure to select Web.

### Authentication not working on localhost

Firebase may restrict localhost. To fix:

1. Go to Firebase Console → Authentication → Settings → Authorized domains
2. Add `localhost` if it's not there

### CORS errors

This is unlikely with the Firebase Web SDK, but if you see CORS issues:

1. Make sure you're using Firebase Authentication (not a custom backend)
2. Check that your domain is authorized in Firebase Console

## Creating Test Accounts

To test email/password login, you can:

1. Go to Firebase Console → Authentication → Users
2. Click "Add user" and create a test account
3. Use those credentials in the login page

Or create a sign-up page in the application (not yet implemented).

## Next Steps

- Implement Sign Up functionality
- Add password reset flow
- Implement Firestore to save user favorites across devices
- Add social authentication (Google, GitHub, etc.)

---

**Note**: The generated `firebase_options.dart` file is already added to `.gitignore` to prevent exposing your Firebase credentials. Make sure to keep it that way!
