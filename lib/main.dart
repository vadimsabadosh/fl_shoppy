import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppy/constants/global_vars.dart';
import 'package:shoppy/features/auth/screens/auth_screen.dart';
import 'package:shoppy/features/auth/services/auth_service.dart';
import 'package:shoppy/providers/user_provider.dart';
import 'package:shoppy/router.dart';

import 'common/widgets/bottom_bar.dart';
import 'features/admin/screens/admin_screen.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => UserProvider(),
      )
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shoppy Demo',
      theme: ThemeData(
        // useMaterial3: true,
        colorScheme: const ColorScheme.light(
          primary: GlobalVariables.secondaryColor,
        ),
        scaffoldBackgroundColor: GlobalVariables.backgroundColor,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
      ),
      onGenerateRoute: generateRoute,
      home: const InitScreen(),
    );
  }
}

class InitScreen extends StatefulWidget {
  const InitScreen({super.key});

  @override
  State<InitScreen> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  final AuthService authService = AuthService();
  @override
  void initState() {
    super.initState();
    authService.getUser(context: context);
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context).user;
    return user.token.isNotEmpty
        ? user.type == 'customer'
            ? const BottomBar()
            : const AdminScreen()
        : const AuthScreen();
  }
}
