
import 'package:flutter/material.dart';

import '../utils/validadores.dart';
import '../viewmodels/auth_viewmodel.dart';

class CadastroView extends StatefulWidget {
  const CadastroView({super.key});

  @override
  State<CadastroView> createState() => _CadastroViewState();
}

class _CadastroViewState extends State<CadastroView> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  final AuthViewModel _viewModel = AuthViewModel();

  String _temaSelecionado = 'Claro';
  bool _notificacoes = true;

  Future<void> _cadastrar() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final resultado = await _viewModel.cadastrar(
      nome: _nomeController.text,
      email: _emailController.text,
      senha: _senhaController.text,
      tema: _temaSelecionado,
      notificacoes: _notificacoes,
    );

    if (!mounted) return;

    if (!resultado) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Este e-mail já está cadastrado!'),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Usuário cadastrado com sucesso!'),
      ),
    );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _nomeController,
                    decoration: const InputDecoration(
                      labelText: 'Nome completo',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    validator: validarNome,
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                    validator: validarEmail,
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _senhaController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Senha',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                    ),
                    validator: validarSenha,
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'Preferências do Aplicativo',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text('Escolha o tema:'),

                  RadioListTile<String>(
                    title: const Text('Tema Claro'),
                    value: 'Claro',
                    groupValue: _temaSelecionado,
                    onChanged: (value) {
                      setState(() {
                        _temaSelecionado = value!;
                      });
                    },
                  ),

                  RadioListTile<String>(
                    title: const Text('Tema Escuro'),
                    value: 'Escuro',
                    groupValue: _temaSelecionado,
                    onChanged: (value) {
                      setState(() {
                        _temaSelecionado = value!;
                      });
                    },
                  ),

                  const Divider(),

                  SwitchListTile(
                    title: const Text('Notificações Ativadas'),
                    subtitle: const Text(
                      'Receber notificações do aplicativo',
                    ),
                    value: _notificacoes,
                    onChanged: (value) {
                      setState(() {
                        _notificacoes = value;
                      });
                    },
                  ),

                  const SizedBox(height: 25),

                  ListenableBuilder(
                    listenable: _viewModel,
                    builder: (context, child) {
                      return SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _viewModel.carregando
                              ? null
                              : _cadastrar,
                          child: _viewModel.carregando
                              ? const CircularProgressIndicator()
                              : const Text('Cadastrar'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
