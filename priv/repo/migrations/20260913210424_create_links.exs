defmodule LinkShortener.Repo.Migrations.CreateLinks do
  use Ecto.Migration

  def change do
    create table(:links) do
      add :original_url, :string
      add :short_code, :string

      timestamps(type: :utc_datetime)
    end
  end
end
