# Relatório de Migração Arquitetural — Edit Doc Flutter

## 1. Mapeamento de Classes e Widgets

O projeto foi migrado de um código único desenvolvido no DartPad para uma estrutura organizada utilizando a arquitetura MVVM (Model-View-ViewModel).

A distribuição das responsabilidades ficou organizada da seguinte forma:

| Arquivo | Responsabilidade |
|---|---|
| `lib/main.dart` | Inicialização do aplicativo, configuração dos temas, rotas e recuperação da sessão do usuário. |
| `lib/models/usuario.dart` | Modelo que representa os dados de um usuário. |
| `lib/models/documento.dart` | Modelo que representa os documentos, incluindo título, conteúdo e datas de criação e atualização. |
| `lib/services/banco_local_service.dart` | Operações locais de cadastro, consulta e autenticação de usuários. |
| `lib/services/preferences_service.dart` | Gerenciamento e armazenamento das preferências de tema, notificações e sessão. |
| `lib/models/services/documento_storage_service.dart` | Armazenamento permanente dos documentos utilizando JSON e SharedPreferences. |
| `lib/viewmodels/auth_viewmodel.dart` | Regras de negócio relacionadas ao cadastro, login e encerramento da sessão. |
| `lib/viewmodels/documentos_viewmodel.dart` | Gerenciamento dos documentos, usuários e preferências, incluindo as operações CRUD. |
| `lib/views/login_view.dart` | Interface da tela de login. |
| `lib/views/cadastro_view.dart` | Interface de cadastro e seleção de preferências. |
| `lib/views/home_view.dart` | Tela principal, listagem de documentos, acesso às preferências e gerenciamento dos documentos. |
| `lib/views/editor_view.dart` | Interface para criação e edição dos documentos. |
| `lib/utils/validadores.dart` | Funções auxiliares para validação de nome, e-mail e senha. |

## 2. Alterações de Estrutura e Imports

Na versão original, as classes, funções e telas estavam concentradas em um único arquivo. Durante a migração, o código foi separado em arquivos menores, de acordo com a responsabilidade de cada parte do aplicativo.

Foram criados arquivos específicos para os modelos, serviços, ViewModels, telas e funções auxiliares.

Também foi necessário organizar os imports para permitir que cada arquivo acessasse as classes e funcionalidades de outros diretórios.

Os modelos passaram a utilizar construtores com parâmetros nomeados e obrigatórios, facilitando a criação dos objetos e deixando mais clara a utilização de seus atributos.

Outra adaptação foi a configuração das rotas nomeadas no arquivo `main.dart`, permitindo navegar entre as telas por meio dos caminhos `/`, `/cadastro` e `/home`.

Com essa organização, o código ficou mais fácil de entender, manter e ampliar.

## 3. Mudanças no Gerenciamento de Estado

Na versão original, boa parte do controle de estado e das regras de negócio estava diretamente nas telas.

Com a migração para MVVM, as responsabilidades foram melhor separadas.

Foram criados dois ViewModels principais:

- **AuthViewModel:** responsável pelas operações de login e cadastro, controle de carregamento, autenticação e encerramento da sessão.
- **DocumentosViewModel:** responsável pelo carregamento dos usuários, gerenciamento das preferências e controle das operações relacionadas aos documentos.

As classes ViewModel utilizam `ChangeNotifier`, permitindo avisar às telas quando algum dado é alterado por meio do método `notifyListeners()`.

Nas telas, o `ListenableBuilder` é utilizado para acompanhar as alterações do estado e atualizar a interface quando necessário.

O `setState()` continua sendo utilizado em situações pontuais de estado local da interface, como controles e componentes que não precisam fazer parte do estado compartilhado da aplicação. A lógica de negócio e os dados compartilhados foram direcionados aos respectivos ViewModels.

Essa mudança tornou a aplicação mais organizada, facilitou a manutenção do código e preparou a estrutura para o armazenamento permanente dos dados.

## 4. Implementação da Persistência de Dados

Na Etapa 5, foi implementado o armazenamento permanente utilizando o pacote `shared_preferences`, permitindo que os dados continuem disponíveis mesmo depois de atualizar ou fechar a página no navegador.

O serviço `PreferencesService` passou a armazenar as preferências do aplicativo, incluindo o tema selecionado, o estado das notificações e a sessão do usuário.

Também foi implementado o `DocumentoStorageService`, responsável por salvar e recuperar os documentos em formato JSON.

Para isso, foi utilizado o pacote `dart:convert`, com as funções `jsonEncode()` e `jsonDecode()`, permitindo converter os objetos em dados que podem ser armazenados e posteriormente recuperados.

O modelo `Documento` foi criado com os seguintes atributos:

- Identificador único;
- Título;
- Conteúdo;
- Data de criação;
- Data da última atualização.

Dessa forma, cada documento pode ser identificado e atualizado individualmente.

## 5. Implementação das Operações CRUD

O gerenciamento dos documentos foi integrado ao `DocumentosViewModel`, que passou a disponibilizar as quatro operações principais:

- **Create (Criar):** permite criar um documento com título e conteúdo.
- **Read (Consultar):** recupera e apresenta os documentos armazenados.
- **Update (Atualizar):** permite modificar o título e o conteúdo de um documento existente.
- **Delete (Excluir):** remove um documento após a confirmação do usuário.

A tela `HomeView` foi adaptada para apresentar a lista de documentos e permitir a criação, edição e exclusão.

A tela `EditorView` também foi modificada para trabalhar tanto com documentos novos quanto com documentos existentes, preenchendo os campos automaticamente durante a edição.

As operações são executadas por meio do ViewModel, que se comunica com o serviço de armazenamento. Assim, as telas ficam responsáveis principalmente pela apresentação e interação com o usuário.

## 6. Testes Realizados

Durante a implementação, foram realizados testes no ambiente Web do Flutter para verificar o funcionamento das funcionalidades desenvolvidas.

Os testes realizados apresentaram os seguintes resultados:

| Funcionalidade | Resultado |
|---|---|
| Cadastro e login de usuários | Aprovado |
| Recuperação da sessão após atualizar a página | Aprovado |
| Encerramento da sessão | Aprovado |
| Persistência do tema selecionado | Aprovado |
| Criação de documentos | Aprovado |
| Listagem de documentos | Aprovado |
| Edição de documentos | Aprovado |
| Exclusão de documentos | Aprovado |
| Persistência dos documentos após atualizar a página | Aprovado |

Também foi executada a análise estática com o comando `flutter analyze`, que retornou `No issues found!`.

## Conclusão

A migração para Flutter com arquitetura MVVM foi realizada com sucesso, e as funcionalidades previstas para a Etapa 5 foram implementadas.

Além da organização da estrutura do código, o aplicativo passou a contar com armazenamento permanente de preferências, sessão de usuário e documentos.

As operações de criação, consulta, edição e exclusão foram testadas no navegador, assim como a recuperação dos dados após atualizar a página.

Com isso, o projeto apresenta uma estrutura mais organizada, facilita futuras alterações e atende aos principais requisitos propostos na atividade.