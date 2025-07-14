import 'package:flutter/material.dart';
import 'package:lttbddnc/screens/notification_screen.dart';
import 'package:provider/provider.dart';
import 'services/mock_auth_service.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ShareEatApp());
}

class ShareEatApp extends StatelessWidget {
  const ShareEatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MockAuthService()),
      ],
      child: MaterialApp(
        title: 'Share-Eat',
        theme: AppTheme.lightTheme,
        home: const AppFlowController(),
        debugShowCheckedModeBanner: false,

        routes: {
          '/notifications': (context) => const NotificationScreen(),
        },
      ),
    );
  }
}

class AppFlowController extends StatefulWidget {
  const AppFlowController({super.key});
  @override
  State<AppFlowController> createState() => _AppFlowControllerState();
}

class _AppFlowControllerState extends State<AppFlowController> {
  bool _onboardingDone = false;

  void _finishOnboarding() {
    setState(() {
      _onboardingDone = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_onboardingDone) {
      return OnboardingScreen(onFinish: _finishOnboarding);
    }
    return const AuthScreen();
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MockAuthService>(
      builder: (context, authService, _) {
        if (authService.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        if (authService.currentUser != null) {
          return const HomeScreen();
        }
        
        return const AuthScreen();
      },
    );
  }
}
