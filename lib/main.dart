
import 'package:flutter/material.dart';

import 'services/preferences_service.dart';
import 'views/cadastro_view.dart';
import 'views/home_view.dart';
import 'views/login_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final temaSalvo = await PreferencesService.carregarTema();

  PreferencesService.temaApp.value =
      temaSalvo == 'Escuro'
          ? ThemeMode.dark
          : ThemeMode.light;

  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: PreferencesService.temaApp,
      builder: (context, temaAtual, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Editor de Documentos',

          themeMode: temaAtual,

          theme: ThemeData(
            brightness: Brightness.light,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.light,
            ),
            useMaterial3: true,
          ),

          darkTheme: ThemeData(
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),

          initialRoute: '/',

          routes: {
            '/': (context) => const LoginView(),
            '/cadastro': (context) => const CadastroView(),
            '/home': (context) => const HomeView(),
          },
        );
      },
    );
  }
}
