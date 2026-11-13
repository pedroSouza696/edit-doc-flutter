
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../documento.dart';

class DocumentoStorageService {
  static const String _chaveDocumentos = 'documentos';

  // READ: recupera todos os documentos salvos.
  Future<List<Documento>> listarDocumentos() async {
    final prefs = await SharedPreferences.getInstance();

    final dados = prefs.getString(_chaveDocumentos);

    if (dados == null || dados.isEmpty) {
      return [];
    }

    final List<dynamic> listaJson = jsonDecode(dados);

    return listaJson.map((item) {
      return Documento.fromJson(
        Map<String, dynamic>.from(item),
      );
    }).toList();
  }

  // CREATE: adiciona um novo documento.
  Future<void> adicionarDocumento(Documento documento) async {
    final documentos = await listarDocumentos();

    documentos.add(documento);

    await _salvarLista(documentos);
  }

  // UPDATE: atualiza um documento existente.
  Future<void> atualizarDocumento(Documento documento) async {
    final documentos = await listarDocumentos();

    final indice = documentos.indexWhere(
      (item) => item.id == documento.id,
    );

    if (indice == -1) {
      return;
    }

    documentos[indice] = documento;

    await _salvarLista(documentos);
  }

  // DELETE: remove um documento pelo identificador.
  Future<void> excluirDocumento(String id) async {
    final documentos = await listarDocumentos();

    documentos.removeWhere(
      (documento) => documento.id == id,
    );

    await _salvarLista(documentos);
  }

  Future<void> _salvarLista(List<Documento> documentos) async {
    final prefs = await SharedPreferences.getInstance();

    final dados = jsonEncode(
      documentos.map((documento) => documento.toJson()).toList(),
    );

    await prefs.setString(_chaveDocumentos, dados);
  }
}
