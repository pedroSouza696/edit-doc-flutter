
import 'package:flutter/material.dart';

import '../models/documento.dart';

class EditorView extends StatefulWidget {
  final Documento? documento;

  const EditorView({
    super.key,
    this.documento,
  });

  @override
  State<EditorView> createState() => _EditorViewState();
}

class _EditorViewState extends State<EditorView> {
  late final TextEditingController _tituloController;
  late final TextEditingController _conteudoController;

  @override
  void initState() {
    super.initState();

    _tituloController = TextEditingController(
      text: widget.documento?.titulo ?? '',
    );

    _conteudoController = TextEditingController(
      text: widget.documento?.conteudo ?? '',
    );
  }

  void _salvarDocumento() {
    final titulo = _tituloController.text.trim();
    final conteudo = _conteudoController.text.trim();

    if (titulo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Digite um título para o documento.'),
        ),
      );
      return;
    }

    if (conteudo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Digite algum conteúdo para o documento.'),
        ),
      );
      return;
    }

    Navigator.pop(
      context,
      {
        'titulo': titulo,
        'conteudo': conteudo,
      },
    );
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _conteudoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final editando = widget.documento != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          editando ? 'Editar Documento' : 'Novo Documento',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(
                labelText: 'Título do documento',
                hintText: 'Digite um título...',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: TextField(
                controller: _conteudoController,
                expands: true,
                maxLines: null,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  hintText: 'Digite seu documento aqui...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _salvarDocumento,
                icon: const Icon(Icons.save),
                label: Text(
                  editando
                      ? 'Salvar alterações'
                      : 'Criar documento',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
