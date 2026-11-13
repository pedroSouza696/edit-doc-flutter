import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/usuario.dart';

class BancoLocalService {
  static const String _chaveUsuarios = 'usuarios';

  // Recupera os usuários armazenados.
  static Future<List<Usuario>> query() async {
    final prefs = await SharedPreferences.getInstance();

    final dados = prefs.getString(_chaveUsuarios);

    if (dados == null || dados.isEmpty) {
      return [];
    }

    final List<dynamic> listaJson = jsonDecode(dados);

    return listaJson.map((item) {
      return Usuario(
        nome: item['nome'] as String,
        email: item['email'] as String,
        senha: item['senha'] as String,
      );
    }).toList();
  }

  // Salva a lista de usuários.
  static Future<void> _salvarUsuarios(
    List<Usuario> usuarios,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    final dados = jsonEncode(
      usuarios.map((usuario) {
        return {
          'nome': usuario.nome,
          'email': usuario.email,
          'senha': usuario.senha,
        };
      }).toList(),
    );

    await prefs.setString(_chaveUsuarios, dados);
  }

  // Cadastra um novo usuário.
  static Future<bool> insert(Usuario usuario) async {
    final usuarios = await query();

    final existe = usuarios.any(
      (u) => u.email.toLowerCase() ==
          usuario.email.toLowerCase(),
    );

    if (existe) {
      return false;
    }

    usuarios.add(usuario);

    await _salvarUsuarios(usuarios);

    return true;
  }

  // Verifica os dados de login.
  static Future<Usuario?> login(
    String email,
    String senha,
  ) async {
    final usuarios = await query();

    for (final usuario in usuarios) {
      if (usuario.email.toLowerCase() ==
              email.toLowerCase() &&
          usuario.senha == senha) {
        return usuario;
      }
    }

    return null;
  }
}