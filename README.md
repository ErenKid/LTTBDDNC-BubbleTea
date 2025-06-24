# Share-Eat: Sustainable Food Sharing App

A Flutter-based mobile application that connects people who have surplus food with those who need it, promoting sustainability and reducing food waste.

## 🌱 Features

### Core Functionality
- **User Authentication**: Secure sign-up and sign-in with Firebase Auth
- **Food Sharing**: Easy-to-use interface for sharing surplus food items
- **Food Discovery**: Browse and search for available food items in your area
- **Category Filtering**: Filter food items by categories (fruits, vegetables, grains, etc.)
- **User Profiles**: Manage your profile and view sharing statistics
- **Real-time Updates**: Live updates for food availability and status

### Food Management
- **Detailed Food Information**: Title, description, quantity, expiry date, allergens
- **Location Services**: Address and pickup instructions for each food item
- **Allergen Information**: Clear labeling of allergens and allergen-free options
- **Expiry Tracking**: Automatic expiry date management and notifications
- **Status Management**: Track food status (available, reserved, claimed, expired)

### User Experience
- **Modern UI/UX**: Beautiful, intuitive interface with sustainable green theme
- **Responsive Design**: Works seamlessly across different screen sizes
- **Search & Filter**: Advanced search and filtering capabilities
- **Rating System**: User ratings and reviews for food quality
- **Push Notifications**: Real-time notifications for food availability

## 🛠️ Technical Stack

- **Framework**: Flutter 3.7.2+
- **State Management**: Provider
- **Backend**: Firebase
  - Authentication: Firebase Auth
  - Database: Cloud Firestore
  - Storage: Firebase Storage
- **UI Components**: Material Design 3
- **Additional Packages**:
  - `image_picker`: Photo upload functionality
  - `geolocator`: Location services
  - `geocoding`: Address geocoding
  - `cached_network_image`: Image caching
  - `intl`: Internationalization
  - `flutter_rating_bar`: Rating components
  - `shared_preferences`: Local storage

## 📱 Screenshots

The app includes the following main screens:

1. **Authentication Screen**: Sign in/Sign up with email and password
2. **Home Screen**: Browse available food items with search and filters
3. **Add Food Screen**: Share your surplus food with detailed information
4. **Profile Screen**: User profile management and statistics
5. **Food Details**: Detailed view of food items with claiming functionality

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.7.2 or higher
- Dart SDK
- Android Studio / VS Code
- Firebase project setup

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd lttbddnc
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create a new Firebase project
   - Enable Authentication (Email/Password)
   - Enable Cloud Firestore
   - Enable Firebase Storage
   - Add your Firebase configuration files:
     - `android/app/google-services.json` (Android)
     - `ios/Runner/GoogleService-Info.plist` (iOS)

4. **Run the app**
   ```bash
   flutter run
   ```

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── user_model.dart       # User data model
│   └── food_item_model.dart  # Food item data model
├── screens/                  # App screens
│   ├── auth_screen.dart      # Authentication screen
│   ├── home_screen.dart      # Main home screen
│   ├── food_list_screen.dart # Food browsing screen
│   ├── add_food_screen.dart  # Food sharing screen
│   └── profile_screen.dart   # User profile screen
├── services/                 # Business logic
│   └── auth_service.dart     # Authentication service
├── theme/                    # App theming
│   └── app_theme.dart        # Theme configuration
└── widgets/                  # Reusable widgets
    └── food_item_card.dart   # Food item display card
```

## 🎨 Design System

The app uses a sustainable green color palette:
- **Primary Green**: #4CAF50
- **Light Green**: #81C784
- **Dark Green**: #2E7D32
- **Accent Green**: #66BB6A
- **Background Green**: #F1F8E9

## 🔧 Configuration

### Firebase Configuration
1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Enable the required services:
   - Authentication (Email/Password)
   - Cloud Firestore
   - Firebase Storage
3. Download and add configuration files to your project

### Environment Variables
Create a `.env` file in the root directory for any environment-specific configurations.

## 📊 Features in Development

- [ ] Push notifications
- [ ] Real-time chat between users
- [ ] Food quality verification system
- [ ] Community features and forums
- [ ] Advanced analytics and reporting
- [ ] Multi-language support
- [ ] Offline mode support

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase for backend services
- The open-source community for various packages
- All contributors and testers

## 📞 Support

For support and questions:
- Create an issue in the repository
- Contact the development team
- Check the documentation

---

**Share-Eat** - Making food sharing sustainable and accessible for everyone! 🌱🍎
