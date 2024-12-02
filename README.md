# Gerenciador de Contatos

Um aplicativo simples para gerenciar contatos, com funcionalidades de cadastro, listagem, edição e exclusão de contatos, seguindo o padrão arquitetural MVC.

---

## Funcionalidades
1. Cadastro de Contato
2. Listagem de Contatos
3. Edição de Contato
4. Exclusão de Contato

---

## Arquitetura

Este projeto utiliza o padrão **MVC (Model-View-Controller)**, que organiza o código em três camadas principais, com responsabilidades bem definidas.

### 1. Camadas do MVC
- **Model:** Define as entidades do sistema, como o contato, incluindo atributos e métodos de interação com o banco de dados.
- **View:** Responsável pela interface gráfica e apresentação de dados para o usuário.
- **Controller:** Gerencia o estado da aplicação, processa interações do usuário e coordena a comunicação entre Model e View.

### 2. Camadas Auxiliares
- **Data:** Configura e gerencia o banco de dados SQLite.
- **Repository:** Abstrai a lógica de persistência de dados, centralizando as operações do banco.

### 3. Fluxo de Dados
1. **View:** Recebe interações do usuário (ex.: salvar ou excluir contato).
2. **Controller:** Processa as interações e aciona as camadas adequadas.
3. **Repository:** Gerencia o acesso e a manipulação dos dados no banco de dados.
4. **Model:** Representa as entidades e encapsula regras básicas de validação ou transformação.


