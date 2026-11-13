
class Documento {
  final String id;
  final String titulo;
  final String conteudo;
  final DateTime dataCriacao;
  final DateTime dataAtualizacao;

  Documento({
    required this.id,
    required this.titulo,
    required this.conteudo,
    required this.dataCriacao,
    required this.dataAtualizacao,
  });

  // Converte o documento para um formato que pode ser salvo em JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'conteudo': conteudo,
      'dataCriacao': dataCriacao.toIso8601String(),
      'dataAtualizacao': dataAtualizacao.toIso8601String(),
    };
  }

  factory Documento.fromJson(Map<String, dynamic> json) {
    return Documento(
      id: json['id'] as String,
      titulo: json['titulo'] as String,
      conteudo: json['conteudo'] as String,
      dataCriacao: DateTime.parse(
        json['dataCriacao'] as String,
      ),
      dataAtualizacao: DateTime.parse(
        json['dataAtualizacao'] as String,
      ),
    );
  }
}
