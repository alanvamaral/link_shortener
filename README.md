# 🔗 LinkShortener

API de encurtamento de URLs desenvolvida com **Elixir e Phoenix**.

O projeto permite que usuários criem e gerenciem links personalizados através de uma API REST. Cada link pertence ao usuário que o criou, enquanto o redirecionamento através do `short_code` permanece público.

Este projeto foi desenvolvido com o objetivo de praticar conceitos de desenvolvimento backend utilizando Elixir, Phoenix, Ecto e PostgreSQL.

## Funcionalidades

- Cadastro de usuários
- Autenticação através de token
- Rotas protegidas
- Criar links encurtados
- Vincular links ao usuário autenticado
- Listar apenas os links do usuário autenticado
- Buscar links pelo `short_code`
- Atualizar parcialmente links com `PATCH`
- Excluir links
- Definir um `short_code` personalizado
- Validação de `short_code` único
- Redirecionamento público através da URL encurtada
- IDs utilizando UUID

## Tecnologias

- Elixir
- Phoenix Framework
- Ecto
- PostgreSQL
- Argon2

## Autenticação

Para acessar as rotas protegidas, primeiro é necessário criar uma conta e realizar login.

### Cadastro

```http
POST /api/auth/register
```

```json
{
  "name": "Alan",
  "email": "alan@example.com",
  "password": "123456789012"
}
```

### Login

```http
POST /api/auth/login
```

```json
{
  "email": "alan@example.com",
  "password": "123456789012"
}
```

Após o login, a API retorna um token que deve ser enviado nas rotas protegidas:

```http
Authorization: Bearer <token>
```

## Criando um link

```http
POST /api/link
Authorization: Bearer <token>
```

```json
{
  "original_url": "https://www.youtube.com",
  "short_code": "youtube"
}
```

O link é automaticamente associado ao usuário autenticado.

Exemplo de resposta:

```json
{
  "id": "uuid-do-link",
  "original_url": "https://www.youtube.com",
  "short_code": "youtube",
  "user_id": "uuid-do-usuario",
  "short_url": "http://localhost:4000/p/youtube"
}
```

## Redirecionamento

Ao acessar:

```text
http://localhost:4000/p/youtube
```

o usuário é redirecionado para:

```text
https://www.youtube.com
```

O redirecionamento é público e não exige autenticação.

## Atualização parcial

É possível alterar somente os campos desejados utilizando `PATCH`.

```http
PATCH /api/link/youtube
Authorization: Bearer <token>
```

Alterando somente a URL:

```json
{
  "original_url": "https://www.google.com"
}
```

Ou alterando somente o código:

```json
{
  "new_short_code": "google"
}
```

## Executando o projeto

Instale as dependências e configure o projeto:

```bash
mix setup
```

Inicie o servidor Phoenix:

```bash
mix phx.server
```

A aplicação estará disponível em:

```text
http://localhost:4000
```

## Objetivo do projeto

Este projeto faz parte dos meus estudos de **Elixir e Phoenix**, com foco em entender na prática:

- APIs REST
- Controllers e rotas
- Pattern Matching
- Pipelines e Plugs
- Autenticação
- Hash de senhas com Argon2
- Tokens de sessão
- Ecto Schemas
- Ecto Changesets
- Contexts
- Associações com `belongs_to` e `has_many`
- Foreign keys
- Queries com Ecto
- Persistência com PostgreSQL
- Constraints e validações
- UUIDs
- Códigos de status HTTP
- Atualizações parciais com `PATCH`
- Autorização baseada no usuário autenticado