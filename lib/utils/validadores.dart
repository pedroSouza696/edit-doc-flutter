
String? validarNome(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Informe seu nome completo';
  }

  if (value.trim().split(RegExp(r'\s+')).length < 2) {
    return 'Informe nome e sobrenome';
  }

  return null;
}

String? validarEmail(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Informe seu e-mail';
  }

  final regex = RegExp(
    r'^[^@\s]+@[^@\s]+\.(com\.br|com)$',
    caseSensitive: false,
  );

  if (!regex.hasMatch(value.trim())) {
    return 'Informe um e-mail válido com final .com ou .com.br';
  }

  return null;
}

String? validarSenha(String? value) {
  if (value == null || value.length < 6) {
    return 'A senha deve ter pelo menos 6 caracteres';
  }

  return null;
}
