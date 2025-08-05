import 'screens/order_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:lttbddnc/screens/notification_screen.dart';
import 'package:provider/provider.dart';
import 'services/mock_auth_service.dart';
import 'services/database_service.dart';
import 'providers/category_provider.dart';
import 'providers/product_provider.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/product_list_screen.dart';
import 'screens/admin_dashboard_screen.dart';
import 'screens/category_crud_screen.dart';
import 'screens/product_crud_screen.dart';
import 'screens/user_management.dart';
import 'screens/statistics_screen.dart';
import 'theme/app_theme.dart';
import 'screens/admin_product_list.dart';
import 'screens/profile_detail_screen.dart';
import 'screens/order_management_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Khởi tạo admin user
  await DatabaseService().createAdminUser();
  
  runApp(const ShareEatApp());
}

class ShareEatApp extends StatelessWidget {
  const ShareEatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MockAuthService()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: MaterialApp(
        title: 'Share-Eat',
        theme: AppTheme.lightTheme,
        home: const AppFlowController(),
        debugShowCheckedModeBanner: false,

        routes: {
          '/auth': (context) => const AuthScreen(),
          '/notifications': (context) => const NotificationScreen(),
          '/admin': (context) => AdminProductListScreen(),
          '/products': (context) => const ProductListScreen(),
          '/admin-dashboard': (context) => const AdminDashboardScreen(),
          '/category-crud': (context) => const CategoryCrudScreen(),
          '/product-crud': (context) => const ProductCrudScreen(),
          '/user-management': (context) => const UserManagementPage(),
          '/statistics': (context) => const StatisticsScreen(),
          '/profile-detail': (context) => const ProfileDetailScreen(),
          '/order-history': (context) => const OrderHistoryScreen(),
          '/order-management': (context) => const OrderManagementScreen(),
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
    return const AuthWrapper();
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
          // Kiểm tra nếu là admin thì chuyển đến admin dashboard
          if (authService.currentUser!.isAdmin) {
            return HomeScreen();
          }
          // User thường thì vào home screen
          return const HomeScreen();
        }
        
        return const AuthScreen();
      },
    );
  }
}
