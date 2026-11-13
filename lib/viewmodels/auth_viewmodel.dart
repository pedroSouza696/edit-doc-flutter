
import 'package:flutter/material.dart';

import '../models/usuario.dart';
import '../services/banco_local_service.dart';
import '../services/preferences_service.dart';

class AuthViewModel extends ChangeNotifier {
  bool carregando = false;

  Usuario? usuarioAutenticado;

  Future<Usuario?> fazerLogin(
    String email,
    String senha,
  ) async {
    carregando = true;
    notifyListeners();

    try {
      usuarioAutenticado = await BancoLocalService.login(
        email.trim(),
        senha,
      );

      if (usuarioAutenticado != null) {
        await PreferencesService.salvarSessao(
          usuarioAutenticado!.email,
        );
      }

      return usuarioAutenticado;
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  Future<bool> cadastrar({
    required String nome,
    required String email,
    required String senha,
    required String tema,
    required bool notificacoes,
  }) async {
    carregando = true;
    notifyListeners();

    try {
      final usuario = Usuario(
        nome: nome.trim(),
        email: email.trim(),
        senha: senha,
      );

      final resultado = await BancoLocalService.insert(
        usuario,
      );

      if (!resultado) {
        return false;
      }

      await PreferencesService.salvarTema(tema);

      await PreferencesService.salvarNotificacoes(
        notificacoes,
      );

      return true;
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  // Encerra a sessão do usuário.
  Future<void> encerrarSessao() async {
    usuarioAutenticado = null;

    await PreferencesService.limparSessao();

    notifyListeners();
  }
}
