# Gain Quest - Flutter App

A revolutionary Flutter application where business challenges meet betting excitement. Win big, risk nothing!

## 🚀 Features

- **Risk-Free Betting**: Users can only win credits, never lose them
- **Business Challenges**: Bet on teams achieving real business milestones
- **Live Streaming**: Watch teams work in real-time with live chat
- **Team Following**: Follow your favorite teams and get notifications
- **Modern UI/UX**: Beautiful onboarding, dark/light theme, smooth animations
- **Firebase Integration**: Real-time data, authentication, and notifications

## 📱 Screenshots

*Screenshots would go here*

## 🏗️ Architecture

The app follows a clean architecture pattern with:

```
lib/
├── core/                   # Common utilities & constants
│   ├── constants/          # App strings, colors, assets
│   ├── utils/              # Helpers (validators, formatters)
│   ├── theme/              # App themes (dark/light)
│   └── widgets/            # Reusable widgets
├── data/                   # Data sources layer
│   ├── models/             # Entity models
│   ├── repositories/       # Abstract repo contracts
│   └── sources/            # Firebase services
├── domain/                 # Business logic
│   ├── entities/           # Pure business models
│   ├── repositories/       # Repository interfaces
│   └── usecases/           # Core logic
├── presentation/           # UI Layer
│   ├── controllers/        # GetX controllers
│   ├── screens/            # UI pages
│   └── widgets/            # Page-specific widgets
└── main.dart               # App entry point
```

## 🛠️ Setup Instructions

### Prerequisites

- Flutter 3.10.0 or higher
- Dart 3.0.0 or higher
- Firebase project
- Android Studio / VS Code

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/sayedsinan/Gain-Quest
   cd Gain-Quest
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   
   a. Create a new Firebase project at https://console.firebase.google.com
   
   b. Enable the following services:
   - Authentication (Email/Password)
   - Cloud Firestore
   - Cloud Storage
   - Cloud Messaging
   
   c. Install FlutterFire CLI:
   ```bash
   dart pub global activate flutterfire_cli
   ```
   
   d. Configure Firebase for your app:
   ```bash
   flutterfire configure
   ```
   
   e. This will automatically update `lib/firebase_options.dart`

4. **Configure Android**
   
   Add the following to `android/app/build.gradle`:
   ```gradle
   android {
       compileSdkVersion 34
       
       defaultConfig {
           minSdkVersion 21
           targetSdkVersion 34
       }
   }
   ```

5. **Configure iOS** (if building for iOS)
   
   Update `ios/Runner/Info.plist` with necessary permissions:
   ```xml
   <key>NSCameraUsageDescription</key>
   <string>Camera access is needed for live streaming</string>
   <key>NSMicrophoneUsageDescription</key>
   <string>Microphone access is needed for live streaming</string>
   ```

6. **Run the app**
   ```bash
   flutter run
   ```

## 🔧 Configuration

### Environment Variables

Create a `.env` file in the root directory (optional):

```env
APP_NAME=Gain Quest
APP_VERSION=1.0.0
DEBUG_MODE=true
```

### Firebase Security Rules

Add these Firestore security rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read and write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Anyone can read teams and challenges
    match /teams/{teamId} {
      allow read: if true;
      allow write: if request.auth != null;
    }
    
    match /challenges/{challengeId} {
      allow read: if true;
      allow write: if request.auth != null;
    }
    
    // Users can read their own bets
    match /bets/{betId} {
      allow read, write: if request.auth != null;
    }
    
    // Live streams are publicly readable
    match /live_streams/{streamId} {
      allow read: if true;
      allow write: if request.auth != null;
      
      match /chat_messages/{messageId} {
        allow read: if true;
        allow write: if request.auth != null;
      }
    }
  }
}
```

## 🧪 Testing

Run tests:
```bash
flutter test
```

## 📦 Building for Production

### Android
```bash
flutter build apk --release
# or
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## 🎯 Key Features Implementation

### 1. Risk-Free Betting System
- Users start with 1000 credits
- Credits are never deducted when placing bets
- Only winning bets add credits to user balance
- Implemented in `FirebaseService.placeBet()` method

### 2. Real-Time Updates
- Live challenge updates using Firestore streams
- Real-time betting results
- Live chat during streams

### 3. Beautiful Animations
- Staggered list animations
- Smooth page transitions
- Loading shimmer effects
- Achievement celebrations

### 4. Modern UI/UX
- Material 3 design system
- Dark/Light theme toggle
- Responsive design
- Intuitive navigation

## 🚨 Important Notes

1. **Demo Data**: The app includes sample data generation for demonstration purposes
2. **Live Streaming**: Uses placeholder UI - integrate with services like Agora, WebRTC, or similar
3. **Push Notifications**: FCM setup included but needs server-side implementation
4. **Image Upload**: Basic image upload functionality included
5. **Permissions**: Camera and microphone permissions needed for live streaming features

## 📋 TODO / Future Enhancements

- [ ] Implement actual live streaming with Agora SDK
- [ ] Add push notification server
- [ ] Implement image upload for profile pictures
- [ ] Add social sharing features
- [ ] Implement advanced betting analytics
- [ ] Add achievements system
- [ ] Create admin panel for managing challenges
- [ ] Add payment integration for credit purchases
- [ ] Implement leaderboards
- [ ] Add team creation functionality

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👨‍💻 Developer Notes

- State management: GetX
- Backend: Firebase (Firestore, Auth, Storage, FCM)
- Architecture: Clean Architecture with Repository pattern
- UI: Material 3 with custom theming
- Animations: Flutter Staggered Animations
- Image handling: Cached Network Image
- Date formatting: Intl package

## 📞 Support

For support and questions, please reach out to the development team.

---

**Gain Quest** - Where business meets betting, and everyone wins! 🚀