
import 'package:flutter/material.dart';

import 'models/usuario.dart';
import 'services/banco_local_service.dart';
import 'services/preferences_service.dart';
import 'views/cadastro_view.dart';
import 'views/home_view.dart';
import 'views/login_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Recupera o tema salvo.
  final temaSalvo = await PreferencesService.carregarTema();

  PreferencesService.temaApp.value =
      temaSalvo == 'Escuro'
          ? ThemeMode.dark
          : ThemeMode.light;

  // Recupera a sessão salva.
  final emailSessao = await PreferencesService.carregarSessao();

  Usuario? usuarioInicial;

  if (emailSessao != null) {
    final usuarios = await BancoLocalService.query();

    for (final usuario in usuarios) {
      if (usuario.email.toLowerCase() ==
          emailSessao.toLowerCase()) {
        usuarioInicial = usuario;
        break;
      }
    }

    // Se o usuário não existir mais, limpa a sessão inválida.
    if (usuarioInicial == null) {
      await PreferencesService.limparSessao();
    }
  }

  runApp(MeuApp(usuarioInicial: usuarioInicial));
}

class MeuApp extends StatelessWidget {
  final Usuario? usuarioInicial;

  const MeuApp({
    super.key,
    this.usuarioInicial,
  });

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

          // Escolhe a primeira tela conforme a sessão.
          initialRoute: usuarioInicial != null ? '/home' : '/',

          routes: {
            '/': (context) => const LoginView(),
            '/cadastro': (context) => const CadastroView(),
            '/home': (context) {
              final nome = ModalRoute.of(context)?.settings.arguments as String?;

              return HomeView(
                nomeUsuarioInicial: nome ?? usuarioInicial?.nome,
  );
},
          },
        );
      },
    );
  }
}
