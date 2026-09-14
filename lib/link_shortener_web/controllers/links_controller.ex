defmodule LinkShortenerWeb.LinksController do
  use LinkShortenerWeb, :controller

  alias LinkShortener.Links

  def get_links(conn, _params) do
    links = Links.list_links()

    data =
      links
      |> Enum.map(&link_json/1)

    conn
    |> put_status(:ok)
    |> json(%{data: data})
  end

  def create_new_link(conn, %{"short_code" => short_code, "original_url" => original_url}) do
    case create_link(original_url, short_code) do
      {:ok, link} ->
        conn
        |> put_status(:created)
        |> json(link_json(link))

      {:error, changeset} ->
        if changeset.errors[:short_code] do
          conn
          |> put_status(:conflict)
          |> json(%{message: "Short code já está em uso"})
        else
          conn
          |> put_status(:unprocessable_entity)
          |> json(%{message: "Erro ao criar link"})
        end
    end
  end

  def delete_link(conn, %{"short_code" => short_code}) do
    case Links.get_by_short_code(short_code) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{message: "Link não encontrado"})

      link ->
        Links.delete_link(link)

        conn
        |> put_status(:ok)
        |> json(%{message: "Link deletado com sucesso!"})
    end
  end

  def update_link(conn, %{"short_code" => short_code} = params) do
    case Links.get_by_short_code(short_code) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{message: "Link não encontrado"})

      link ->
        attrs =
          %{}
          |> maybe_put(:original_url, params["original_url"])
          |> maybe_put(:short_code, params["new_short_code"])

        case Links.update_link(link, attrs) do
          {:ok, updated_link} ->
            conn
            |> put_status(:ok)
            |> json(link_json(updated_link))

          {:error, _changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{message: "Erro ao atualizar link"})
        end
    end
  end

  def redirect_by_short_code(conn, %{"short_code" => short_code}) do
    case Links.get_by_short_code(short_code) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{message: "Link não encontrado"})

      link ->
        redirect(conn, external: link.original_url)
    end
  end

  def get_link_by_short_code(conn, %{"short_code" => short_code}) do
    case Links.get_by_short_code(short_code) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{message: "Link não encontrado"})

      link ->
        conn
        |> put_status(:ok)
        |> json(link_json(link))
    end
  end

  defp create_link(original_url, short_code) do
    Links.create_link(%{
      original_url: original_url,
      short_code: short_code
    })
  end

  defp maybe_put(map, _key, nil), do: map
  defp maybe_put(map, key, value), do: Map.put(map, key, value)

  defp link_json(link) do
    %{
      id: link.id,
      original_url: link.original_url,
      short_code: link.short_code,
      short_url: short_url(link.short_code)
    }
  end

  defp short_url(short_code) do
    "#{LinkShortenerWeb.Endpoint.url()}/p/#{short_code}"
  end
end
