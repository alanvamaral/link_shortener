defmodule LinkShortenerWeb.Router do
  use LinkShortenerWeb, :router

  import LinkShortenerWeb.Plugs.UserAuth

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_current_scope_for_user
  end

  pipeline :authenticated do
    plug :require_authenticated_user
  end

  scope "/api", LinkShortenerWeb do
    pipe_through :api
    post "/auth/register", AuthController, :register
    post "/auth/login", AuthController, :login
  end

  scope "/api", LinkShortenerWeb do
    pipe_through [:api, :authenticated]

    get "/me", AuthController, :me

    get "/links", LinksController, :get_links
    post "/link", LinksController, :create_new_link
    delete "/link/:short_code", LinksController, :delete_link
    get "/link/:short_code", LinksController, :get_link_by_short_code
    patch "/link/:short_code", LinksController, :update_link
  end

  scope "/p", LinkShortenerWeb do
    pipe_through :api

    get "/:short_code", LinksController, :redirect_by_short_code
  end
end
