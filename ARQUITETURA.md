# Relatório de Migração Arquitetural — Edit Doc Flutter

## 1. Mapeamento de Classes e Widgets

O projeto foi migrado de um código único desenvolvido no DartPad para uma estrutura organizada utilizando a arquitetura MVVM (Model-View-ViewModel).

A distribuição das responsabilidades ficou organizada da seguinte forma:

| Arquivo | Responsabilidade |
|---|---|
| `lib/main.dart` | Inicialização do aplicativo, configuração dos temas e rotas nomeadas. |
| `lib/models/usuario.dart` | Modelo que representa os dados de um usuário. |
| `lib/services/banco_local_service.dart` | Operações locais de cadastro, consulta e autenticação de usuários. |
| `lib/services/preferences_service.dart` | Gerenciamento das preferências de tema e notificações. |
| `lib/viewmodels/auth_viewmodel.dart` | Regras de negócio relacionadas ao cadastro e login. |
| `lib/viewmodels/documentos_viewmodel.dart` | Gerenciamento dos usuários, preferências e conteúdo do documento. |
| `lib/views/login_view.dart` | Interface da tela de login. |
| `lib/views/cadastro_view.dart` | Interface de cadastro e seleção de preferências. |
| `lib/views/home_view.dart` | Tela principal, listagem de usuários, preferências e acesso ao editor. |
| `lib/views/editor_view.dart` | Interface de edição do documento. |
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

- **AuthViewModel:** responsável pelas operações de login e cadastro, controle de carregamento e comunicação com o serviço de usuários.
- **DocumentosViewModel:** responsável pelo carregamento dos usuários, gerenciamento das preferências e atualização do conteúdo do documento.

As classes ViewModel utilizam `ChangeNotifier`, permitindo avisar às telas quando algum dado é alterado por meio do método `notifyListeners()`.

Nas telas, o `ListenableBuilder` é utilizado para acompanhar as alterações do estado e atualizar a interface quando necessário.

O `setState()` continua sendo utilizado em situações pontuais de estado local da interface, como controles e componentes que não precisam fazer parte do estado global da aplicação. A lógica de negócio e os dados compartilhados foram direcionados aos respectivos ViewModels.

Essa mudança tornou a aplicação mais organizada, facilitou a manutenção do código e preparou a estrutura para a implementação das operações CRUD e da persistência de dados na próxima etapa.

## Conclusão

A migração para Flutter com arquitetura MVVM foi realizada com sucesso. O aplicativo foi testado no ambiente Web, incluindo cadastro, login, navegação, edição de documentos e preferências de tema e notificações.

Também foi executada a análise estática com o comando `flutter analyze`, que retornou `No issues found!`.

O código foi versionado e enviado ao repositório público no GitHub por meio de commit e push.

A estrutura atual está preparada para receber as funcionalidades de CRUD e persistência local previstas para a Etapa 5.