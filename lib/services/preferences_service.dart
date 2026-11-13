
import 'package:flutter/material.dart';

class PreferencesService {
  static final Map<String, dynamic> _dados = {};

  // Controla o tema do aplicativo inteiro.
  static final ValueNotifier<ThemeMode> temaApp =
      ValueNotifier<ThemeMode>(ThemeMode.light);

  static Future<void> salvarTema(String tema) async {
    _dados['tema'] = tema;

    temaApp.value = tema == 'Escuro'
        ? ThemeMode.dark
        : ThemeMode.light;
  }

  static Future<void> salvarNotificacoes(bool ativo) async {
    _dados['notificacoes'] = ativo;
  }

  static Future<String> carregarTema() async {
    return _dados['tema'] ?? 'Claro';
  }

  static Future<bool> carregarNotificacoes() async {
    return _dados['notificacoes'] ?? true;
  }
}
