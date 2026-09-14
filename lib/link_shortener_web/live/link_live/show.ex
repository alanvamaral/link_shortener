defmodule LinkShortenerWeb.LinkLive.Show do
  use LinkShortenerWeb, :live_view

  alias LinkShortener.Links

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Link {@link.id}
        <:subtitle>This is a link record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/#{@link}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit link
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Original url">{@link.original_url}</:item>
        <:item title="Short code">{@link.short_code}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Link")
     |> assign(:link, Links.get_link!(id))}
  end
end
