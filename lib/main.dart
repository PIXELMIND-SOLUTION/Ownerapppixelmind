import 'package:client_support_app/provider/auth/auth_provider.dart';
import 'package:client_support_app/provider/auth/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const ClientVaultApp());
}

class ClientVaultApp extends StatelessWidget {
  const ClientVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider()..restoreSession(),
        ),
        ChangeNotifierProvider(create: (_) => ClientProvider()),
      ],
      child: MaterialApp(
        title: 'ClientVault',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const _AppGate(),
      ),
    );
  }
}

class _AppGate extends StatelessWidget {
  const _AppGate();

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = context.select<AuthProvider, bool>((a) => a.isLoggedIn);
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: isLoggedIn
          ? const HomeScreen(key: ValueKey('home'))
          : const LoginScreen(key: ValueKey('login')),
    );
  }
}