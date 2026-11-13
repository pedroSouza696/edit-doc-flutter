
import 'package:flutter/material.dart';

import '../models/usuario.dart';
import '../models/documento.dart';
import '../services/banco_local_service.dart';
import '../services/preferences_service.dart';
import '../models/services/documento_storage_service.dart';

class DocumentosViewModel extends ChangeNotifier {
  final DocumentoStorageService _storageService =
      DocumentoStorageService();

  List<Usuario> usuarios = [];

  List<Documento> documentos = [];

  String temaSelecionado = 'Claro';

  bool notificacoes = true;

  bool carregando = false;

  String conteudoDocumento =
      'Bem-vindo ao seu Editor de Documentos!\n\n'
      'Aqui você pode redigir notas, editar arquivos '
      'de texto e gerenciar seus documentos.';

  // Carrega os usuários cadastrados.
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

  // Carrega as preferências do aplicativo.
  Future<void> carregarPreferencias() async {
    temaSelecionado =
        await PreferencesService.carregarTema();

    notificacoes =
        await PreferencesService.carregarNotificacoes();

    notifyListeners();
  }

  // Altera o tema do aplicativo.
  Future<void> alterarTema(String tema) async {
    temaSelecionado = tema;
    await PreferencesService.salvarTema(tema);
    notifyListeners();
  }

  // Altera as notificações.
  Future<void> alterarNotificacoes(bool ativo) async {
    notificacoes = ativo;
    await PreferencesService.salvarNotificacoes(ativo);
    notifyListeners();
  }

  // Carrega os documentos salvos permanentemente.
  Future<void> carregarDocumentos() async {
    carregando = true;
    notifyListeners();

    try {
      documentos = await _storageService.listarDocumentos();
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  // CREATE: cria um novo documento.
  Future<void> criarDocumento({
    required String titulo,
    required String conteudo,
  }) async {
    final agora = DateTime.now();

    final documento = Documento(
      id: agora.microsecondsSinceEpoch.toString(),
      titulo: titulo,
      conteudo: conteudo,
      dataCriacao: agora,
      dataAtualizacao: agora,
    );

    await _storageService.adicionarDocumento(documento);

    documentos = await _storageService.listarDocumentos();

    notifyListeners();
  }

  // UPDATE: atualiza um documento existente.
  Future<void> editarDocumento({
    required Documento documento,
    required String titulo,
    required String conteudo,
  }) async {
    final documentoAtualizado = Documento(
      id: documento.id,
      titulo: titulo,
      conteudo: conteudo,
      dataCriacao: documento.dataCriacao,
      dataAtualizacao: DateTime.now(),
    );

    await _storageService.atualizarDocumento(
      documentoAtualizado,
    );

    documentos = await _storageService.listarDocumentos();

    notifyListeners();
  }

  // DELETE: exclui um documento.
  Future<void> excluirDocumento(String id) async {
    await _storageService.excluirDocumento(id);

    documentos = await _storageService.listarDocumentos();

    notifyListeners();
  }

  // Mantém a atualização do editor antigo durante a integração.
  void atualizarDocumento(String conteudo) {
    conteudoDocumento = conteudo;
    notifyListeners();
  }

  void salvarDocumento() {
    notifyListeners();
  }
}
