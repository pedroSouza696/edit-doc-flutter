
import 'package:flutter/material.dart';

import '../models/usuario.dart';
import '../services/banco_local_service.dart';
import '../services/preferences_service.dart';

class DocumentosViewModel extends ChangeNotifier {
  List<Usuario> usuarios = [];

  String temaSelecionado = 'Claro';

  bool notificacoes = true;

  bool carregando = false;

  String conteudoDocumento =
      'Bem-vindo ao seu Editor de Documentos!\n\n'
      'Aqui você pode redigir notas, editar arquivos '
      'de texto e gerenciar seus documentos.';

  // CARREGAR USUÁRIOS

  Future<void> carregarUsuarios() async {
    carregando = true;
    notifyListeners();

    try {
      usuarios = await BancoLocalService.query();
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  // CARREGAR PREFERÊNCIAS

  Future<void> carregarPreferencias() async {
    temaSelecionado =
        await PreferencesService.carregarTema();

    notificacoes =
        await PreferencesService.carregarNotificacoes();

    notifyListeners();
  }

  // ALTERAR TEMA

  Future<void> alterarTema(String tema) async {
    temaSelecionado = tema;

    await PreferencesService.salvarTema(tema);

    notifyListeners();
  }

  // ALTERAR NOTIFICAÇÕES

  Future<void> alterarNotificacoes(bool ativo) async {
    notificacoes = ativo;

    await PreferencesService.salvarNotificacoes(ativo);

    notifyListeners();
  }

  // ATUALIZAR CONTEÚDO DO DOCUMENTO

  void atualizarDocumento(String conteudo) {
    conteudoDocumento = conteudo;
    notifyListeners();
  }

  // SALVAR DOCUMENTO

  void salvarDocumento() {
    notifyListeners();
  }
}
