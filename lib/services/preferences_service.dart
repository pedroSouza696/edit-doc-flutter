
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _chaveTema = 'tema';
  static const String _chaveNotificacoes = 'notificacoes';

  static final ValueNotifier<ThemeMode> temaApp =
      ValueNotifier<ThemeMode>(ThemeMode.light);

  static Future<void> salvarTema(String tema) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_chaveTema, tema);

    temaApp.value = tema == 'Escuro'
        ? ThemeMode.dark
        : ThemeMode.light;
  }

  static Future<void> salvarNotificacoes(bool ativo) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_chaveNotificacoes, ativo);
  }

  static Future<String> carregarTema() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(_chaveTema) ?? 'Claro';
  }

  static Future<bool> carregarNotificacoes() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_chaveNotificacoes) ?? true;
  }

  // Salva a sessão do usuário.
  static Future<void> salvarSessao(String email) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('sessao_usuario', email);
  }

  // Recupera a sessão salva.
  static Future<String?> carregarSessao() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('sessao_usuario');
  }

  // Encerra a sessão.
  static Future<void> limparSessao() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('sessao_usuario');
  }
}
