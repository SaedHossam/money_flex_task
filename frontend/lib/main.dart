import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/providers/customer_provider.dart';
import 'package:frontend/services/api_service.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/views/auth/login_screen.dart';
import 'package:frontend/views/customer/customer_list_screen.dart';
import 'package:frontend/views/customer/customer_form_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final authService = AuthService();
  final token = await authService.getToken();
  final apiService = ApiService(authService: authService);
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(authService: authService, apiService: apiService)),
        ChangeNotifierProvider(create: (_) => CustomerProvider(apiService)),
      ],
      child: MyApp(apiService: apiService, isLoggedIn: token != null),
    ),
  );
}

class MyApp extends StatelessWidget {
  final ApiService apiService;
  final bool isLoggedIn;

  const MyApp({required this.apiService, required this.isLoggedIn, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Customer Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: isLoggedIn ? '/customers' : '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/customers': (context) => CustomerListScreen(),
        '/customers/create': (context) => CustomerFormScreen(),
      },
    );
  }
}