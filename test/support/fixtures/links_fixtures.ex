defmodule LinkShortener.LinksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LinkShortener.Links` context.
  """

  @doc """
  Generate a link.
  """
  def link_fixture(attrs \\ %{}) do
    {:ok, link} =
      attrs
      |> Enum.into(%{
        original_url: "some original_url",
        short_code: "some short_code"
      })
      |> LinkShortener.Links.create_link()

    link
  end
end
