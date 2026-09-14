defmodule LinkShortenerWeb.Plugs.UserAuth do
  import Plug.Conn
  import Phoenix.Controller

  alias LinkShortener.Accounts
  alias LinkShortener.Accounts.Scope

  def fetch_current_scope_for_user(conn, _opts) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, decoded_token} <- Base.url_decode64(token, padding: false),
         {user, _token_inserted_at} <-
           Accounts.get_user_by_session_token(decoded_token) do
      assign(conn, :current_scope, Scope.for_user(user))
    else
      _ ->
        assign(conn, :current_scope, Scope.for_user(nil))
    end
  end

  def require_authenticated_user(conn, _opts) do
    if conn.assigns.current_scope && conn.assigns.current_scope.user do
      conn
    else
      conn
      |> put_status(:unauthorized)
      |> json(%{message: "Não autenticado"})
      |> halt()
    end
  end
end
