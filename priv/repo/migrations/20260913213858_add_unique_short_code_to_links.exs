defmodule LinkShortener.Repo.Migrations.AddUniqueShortCodeToLinks do
  use Ecto.Migration

  def change do
    create unique_index(:links, [:short_code])
  end
end
