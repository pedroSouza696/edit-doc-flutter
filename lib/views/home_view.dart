
import 'package:flutter/material.dart';

import '../models/documento.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/documentos_viewmodel.dart';
import 'editor_view.dart';

class HomeView extends StatefulWidget {
  final String? nomeUsuarioInicial;

  const HomeView({
    super.key,
    this.nomeUsuarioInicial,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final DocumentosViewModel _viewModel = DocumentosViewModel();
  final AuthViewModel _authViewModel = AuthViewModel();

  String _nomeUsuario = 'Usuário';

  @override
  void initState() {
    super.initState();

    _viewModel.carregarUsuarios();
    _viewModel.carregarPreferencias();
    _viewModel.carregarDocumentos();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _nomeUsuario =
        ModalRoute.of(context)?.settings.arguments as String? ??
        widget.nomeUsuarioInicial ??
        'Usuário';
  }

  // Mostra os usuários cadastrados.
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

  // Mostra as preferências do aplicativo.
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
                  RadioGroup<String>(
                    groupValue: _viewModel.temaSelecionado,
                    onChanged: (value) async {
                      if (value == null) return;

                      await _viewModel.alterarTema(value);

                      setDialogState(() {});
                    },
                    child: Column(
                      children: [
                        RadioListTile<String>(
                          title: const Text('Tema Claro'),
                          value: 'Claro',
                        ),
                        RadioListTile<String>(
                          title: const Text('Tema Escuro'),
                          value: 'Escuro',
                        ),
                      ],
                    ),
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

  // Abre o editor para criar ou editar um documento.
  Future<void> _abrirEditor({Documento? documento}) async {
    final resultado = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(
        builder: (context) => EditorView(
          documento: documento,
        ),
      ),
    );

    if (resultado == null || !mounted) return;

    final titulo = resultado['titulo']!;
    final conteudo = resultado['conteudo']!;

    if (documento == null) {
      await _viewModel.criarDocumento(
        titulo: titulo,
        conteudo: conteudo,
      );
    } else {
      await _viewModel.editarDocumento(
        documento: documento,
        titulo: titulo,
        conteudo: conteudo,
      );
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          documento == null
              ? 'Documento criado com sucesso!'
              : 'Documento atualizado com sucesso!',
        ),
      ),
    );
  }

  // Confirma e exclui um documento.
  Future<void> _excluirDocumento(Documento documento) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Excluir documento'),
          content: Text(
            'Deseja realmente excluir "${documento.titulo}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (confirmar != true) return;

    await _viewModel.excluirDocumento(documento.id);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Documento excluído com sucesso!'),
      ),
    );
  }

  // Encerra a sessão do usuário.
  Future<void> _sair() async {
    await _authViewModel.encerrarSessao();

    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/',
      (route) => false,
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _authViewModel.dispose();
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
            onPressed: _sair,
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
                  'Meus documentos',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                Expanded(
                  child: _viewModel.carregando
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : _viewModel.documentos.isEmpty
                          ? const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.description_outlined,
                                    size: 64,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    'Nenhum documento criado ainda.',
                                  ),
                                  Text(
                                    'Clique no botão abaixo para começar.',
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: _viewModel.documentos.length,
                              itemBuilder: (context, index) {
                                final documento =
                                    _viewModel.documentos[index];

                                return Card(
                                  margin: const EdgeInsets.only(
                                    bottom: 10,
                                  ),
                                  child: ListTile(
                                    leading: const Icon(
                                      Icons.description,
                                      size: 35,
                                      color: Colors.blue,
                                    ),
                                    title: Text(documento.titulo),
                                    subtitle: Text(
                                      documento.conteudo,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    onTap: () {
                                      _abrirEditor(
                                        documento: documento,
                                      );
                                    },
                                    trailing: PopupMenuButton<String>(
                                      onSelected: (opcao) {
                                        if (opcao == 'editar') {
                                          _abrirEditor(
                                            documento: documento,
                                          );
                                        } else if (opcao == 'excluir') {
                                          _excluirDocumento(documento);
                                        }
                                      },
                                      itemBuilder: (context) => [
                                        const PopupMenuItem(
                                          value: 'editar',
                                          child: Row(
                                            children: [
                                              Icon(Icons.edit),
                                              SizedBox(width: 8),
                                              Text('Editar'),
                                            ],
                                          ),
                                        ),
                                        const PopupMenuItem(
                                          value: 'excluir',
                                          child: Row(
                                            children: [
                                              Icon(Icons.delete),
                                              SizedBox(width: 8),
                                              Text('Excluir'),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () => _abrirEditor(),
                    icon: const Icon(Icons.add),
                    label: const Text('Novo documento'),
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
