defmodule LinkShortenerWeb.LinkLive.Index do
  use LinkShortenerWeb, :live_view

  alias LinkShortener.Links

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Listing Links
        <:actions>
          <.button variant="primary" navigate={~p"/new"}>
            <.icon name="hero-plus" /> New Link
          </.button>
        </:actions>
      </.header>

      <.table
        id="links"
        rows={@streams.links}
        row_click={fn {_id, link} -> JS.navigate(~p"/#{link}") end}
      >
        <:col :let={{_id, link}} label="Original url">{link.original_url}</:col>
        <:col :let={{_id, link}} label="Short code">{link.short_code}</:col>
        <:action :let={{_id, link}}>
          <div class="sr-only">
            <.link navigate={~p"/#{link}"}>Show</.link>
          </div>
          <.link navigate={~p"/#{link}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, link}}>
          <.link
            phx-click={JS.push("delete", value: %{id: link.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Listing Links")
     |> stream(:links, list_links())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    link = Links.get_link!(id)
    {:ok, _} = Links.delete_link(link)

    {:noreply, stream_delete(socket, :links, link)}
  end

  defp list_links() do
    Links.list_links()
  end
end
