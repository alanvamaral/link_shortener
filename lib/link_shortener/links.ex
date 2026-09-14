defmodule LinkShortener.Links do
  import Ecto.Query, warn: false
  alias LinkShortener.Repo

  alias LinkShortener.Links.Link

  def list_links do
    Repo.all(Link)
  end

  def list_links_by_user_id(user_id) do
    Repo.all(from(link in Link, where: link.user_id == ^user_id))
  end

  def get_link!(id), do: Repo.get!(Link, id)

  def create_link(user, attrs) do
    %Link{user_id: user.id}
    |> Link.changeset(attrs)
    |> Repo.insert()
  end

  def update_link(%Link{} = link, attrs) do
    link
    |> Link.changeset(attrs)
    |> Repo.update()
  end

  def delete_link(%Link{} = link) do
    Repo.delete(link)
  end

  def change_link(%Link{} = link, attrs \\ %{}) do
    Link.changeset(link, attrs)
  end

  def get_by_short_code(short_code) do
    Repo.get_by(Link, short_code: short_code)
  end

  def get_by_short_code_and_user_id(short_code, user_id) do
    Repo.get_by(Link, short_code: short_code, user_id: user_id)
  end
end
