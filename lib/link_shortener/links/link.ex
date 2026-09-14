defmodule LinkShortener.Links.Link do
  use Ecto.Schema
  import Ecto.Changeset

  alias LinkShortener.Accounts.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "links" do
    field :original_url, :string
    field :short_code, :string

    belongs_to :user, User, type: :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(link, attrs) do
    link
    |> cast(attrs, [:original_url, :short_code])
    |> validate_required([:original_url, :short_code])
    |> unique_constraint(:short_code)
  end
end
