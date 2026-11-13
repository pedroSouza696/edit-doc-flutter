
import '../models/usuario.dart';

class BancoLocalService {
  static final List<Usuario> _usuarios = [];

  static Future<bool> insert(Usuario usuario) async {
    await Future.delayed(
      const Duration(milliseconds: 300),
    );

    final existe = _usuarios.any(
      (u) => u.email.toLowerCase() ==
          usuario.email.toLowerCase(),
    );

    if (existe) {
      return false;
    }

    _usuarios.add(usuario);
    return true;
  }

  static Future<List<Usuario>> query() async {
    await Future.delayed(
      const Duration(milliseconds: 300),
    );

    return List<Usuario>.from(_usuarios);
  }

  static Future<Usuario?> login(
    String email,
    String senha,
  ) async {
    await Future.delayed(
      const Duration(milliseconds: 300),
    );

    for (final usuario in _usuarios) {
      if (usuario.email.toLowerCase() ==
              email.toLowerCase() &&
          usuario.senha == senha) {
        return usuario;
      }
    }

    return null;
  }
}
