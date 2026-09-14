defmodule LinkShortener.LinksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LinkShortener.Links` context.
  """

  @doc """
  Generate a link.
  """
  def link_fixture(user, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        original_url: "some original_url",
        short_code: "some short_code"
      })

    {:ok, link} = LinkShortener.Links.create_link(user, attrs)

    link
  end
end
