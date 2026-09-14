defmodule LinkShortenerWeb.Router do
  use LinkShortenerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {LinkShortenerWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LinkShortenerWeb do
    pipe_through :browser

    live "/", LinkLive.Index, :index
    live "/new", LinkLive.Form, :new
    live "/:id", LinkLive.Show, :show
    live "/:id/edit", LinkLive.Form, :edit
  end

  scope "/api", LinkShortenerWeb do
    pipe_through :api

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
