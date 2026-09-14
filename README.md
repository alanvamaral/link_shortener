# 🔗 LinkShortener

API de encurtamento de URLs desenvolvida com **Elixir e Phoenix**.

O projeto permite criar links personalizados, consultar, atualizar e excluir links, além de redirecionar URLs através de um `short_code`.

Este projeto foi desenvolvido com o objetivo de praticar conceitos de desenvolvimento backend utilizando Elixir, Phoenix, Ecto e PostgreSQL.

## Funcionalidades

- Criar links encurtados
- Definir um `short_code` personalizado
- Redirecionar através da URL encurtada
- Listar todos os links
- Buscar um link pelo `short_code`
- Atualizar parcialmente um link com `PATCH`
- Alterar a URL original e/ou o `short_code`
- Excluir links
- Validação de `short_code` único

## Tecnologias

- Elixir
- Phoenix Framework
- Ecto
- PostgreSQL

## Exemplo

Criando um link:

```http
POST /api/link
```

```json
{
  "original_url": "https://www.youtube.com",
  "short_code": "youtube"
}
```

Resposta:

```json
{
  "id": 1,
  "original_url": "https://www.youtube.com",
  "short_code": "youtube",
  "short_url": "http://localhost:4000/p/youtube"
}
```

Ao acessar:

```text
http://localhost:4000/p/youtube
```

o usuário é redirecionado para:

```text
https://www.youtube.com
```

## Atualização parcial

É possível alterar somente os campos desejados utilizando `PATCH`.

```http
PATCH /api/link/youtube
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

Clone o repositório e instale as dependências:

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
- Ecto Changesets
- Contexts
- Persistência com PostgreSQL
- Constraints e validações
- Códigos de status HTTP
- Atualizações parciais com PATCH