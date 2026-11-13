import 'package:flutter/material.dart';

import '../viewmodels/documentos_viewmodel.dart';
import 'editor_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final DocumentosViewModel _viewModel = DocumentosViewModel();

  String _nomeUsuario = 'Usuário';

  @override
  void initState() {
    super.initState();

    _viewModel.carregarUsuarios();
    _viewModel.carregarPreferencias();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _nomeUsuario =
        ModalRoute.of(context)?.settings.arguments as String? ??
            'Usuário';
  }

  Future<void> _mostrarUsuarios() async {
    await _viewModel.carregarUsuarios();

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Usuários Cadastrados'),
          content: SizedBox(
            width: double.maxFinite,
            child: _viewModel.usuarios.isEmpty
                ? const Text('Nenhum usuário cadastrado.')
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: _viewModel.usuarios.length,
                    itemBuilder: (context, index) {
                      final usuario = _viewModel.usuarios[index];

                      return ListTile(
                        leading: const Icon(
                          Icons.person,
                          color: Colors.blue,
                        ),
                        title: Text(usuario.nome),
                        subtitle: Text(usuario.email),
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _mostrarPreferencias() async {
    await _viewModel.carregarPreferencias();

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Preferências do Aplicativo'),
          content: StatefulBuilder(
            builder: (context, setDialogState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Escolha o tema:'),
                  ),

                  RadioListTile<String>(
                    title: const Text('Tema Claro'),
                    value: 'Claro',
                    groupValue: _viewModel.temaSelecionado,
                    onChanged: (value) async {
                      await _viewModel.alterarTema(value!);
                      setDialogState(() {});
                    },
                  ),

                  RadioListTile<String>(
                    title: const Text('Tema Escuro'),
                    value: 'Escuro',
                    groupValue: _viewModel.temaSelecionado,
                    onChanged: (value) async {
                      await _viewModel.alterarTema(value!);
                      setDialogState(() {});
                    },
                  ),

                  const Divider(),

                  SwitchListTile(
                    title: const Text('Notificações Ativadas'),
                    subtitle: const Text(
                      'Receber notificações do aplicativo',
                    ),
                    value: _viewModel.notificacoes,
                    onChanged: (value) async {
                      await _viewModel.alterarNotificacoes(value);
                      setDialogState(() {});
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  
  Future<void> _abrirEditor() async {
    final conteudoAtualizado = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => EditorView(
          conteudoInicial: _viewModel.conteudoDocumento,
        ),
      ),
    );

    if (conteudoAtualizado != null) {
      _viewModel.atualizarDocumento(conteudoAtualizado);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Documento atualizado com sucesso!'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Biblioteca de Documentos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.people),
            tooltip: 'Usuários cadastrados',
            onPressed: _mostrarUsuarios,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Preferências',
            onPressed: _mostrarPreferencias,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, child) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Olá, $_nomeUsuario!',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Bem-vindo à sua biblioteca de documentos.',
                ),
                const SizedBox(height: 24),
                const Text(
                  'Meu documento',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Card(
                    child: ListTile(
                      leading: const Icon(
                        Icons.description,
                        size: 35,
                        color: Colors.blue,
                      ),
                      title: const Text('Meu documento'),
                      subtitle: Text(
                        _viewModel.conteudoDocumento,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: const Icon(Icons.edit),
                      onTap: _abrirEditor,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _abrirEditor,
                    icon: const Icon(Icons.edit),
                    label: const Text('Abrir editor'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
