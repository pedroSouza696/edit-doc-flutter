
import 'package:flutter/material.dart';

class EditorView extends StatefulWidget {
  final String? conteudoInicial;

  const EditorView({
    super.key,
    this.conteudoInicial,
  });

  @override
  State<EditorView> createState() => _EditorViewState();
}

class _EditorViewState extends State<EditorView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(
      text: widget.conteudoInicial ??
          'Bem-vindo ao seu Editor de Documentos!\n\n'
              'Aqui você pode redigir notas, editar arquivos '
              'de texto e gerenciar seus documentos.',
    );
  }

  void _salvarDocumento() {
    Navigator.pop(context, _controller.text);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editor de Documentos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
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
                label: const Text('Salvar documento'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
