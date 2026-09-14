defmodule LinkShortenerWeb.AuthController do
  use LinkShortenerWeb, :controller

  alias LinkShortener.Accounts

  def me(conn, _params) do
    user = conn.assigns.current_scope.user

    json(conn, %{
      id: user.id,
      name: user.name,
      email: user.email,
      role: user.role
    })
  end

  def register(conn, params) do
    case Accounts.register_user(params) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> json(%{
          id: user.id,
          name: user.name,
          email: user.email,
          role: user.role
        })

      {:error, changeset} ->
        if email_already_exists?(changeset) do
          conn
          |> put_status(:conflict)
          |> json(%{message: "E-mail já cadastrado"})
        else
          conn
          |> put_status(:unprocessable_entity)
          |> json(%{message: "Erro ao criar usuário"})
        end
    end
  end

  def login(conn, %{"email" => email, "password" => password}) do
    case Accounts.get_user_by_email_and_password(email, password) do
      nil ->
        conn
        |> put_status(:unauthorized)
        |> json(%{message: "Email ou senha inválidos"})

      user ->
        encoded_token =
          user
          |> Accounts.generate_user_session_token()
          |> Base.url_encode64(padding: false)

        json(conn, %{token: encoded_token})
    end
  end

  defp email_already_exists?(changeset) do
    Enum.any?(changeset.errors, fn
      {:email, {_message, metadata}} ->
        metadata[:constraint] == :unique ||
          metadata[:validation] == :unsafe_unique

      _ ->
        false
    end)
  end
end
