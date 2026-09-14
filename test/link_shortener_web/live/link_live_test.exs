defmodule LinkShortenerWeb.LinkLiveTest do
  use LinkShortenerWeb.ConnCase

  import Phoenix.LiveViewTest
  import LinkShortener.LinksFixtures

  @create_attrs %{original_url: "some original_url", short_code: "some short_code"}
  @update_attrs %{original_url: "some updated original_url", short_code: "some updated short_code"}
  @invalid_attrs %{original_url: nil, short_code: nil}
  defp create_link(_) do
    link = link_fixture()

    %{link: link}
  end

  describe "Index" do
    setup [:create_link]

    test "lists all links", %{conn: conn, link: link} do
      {:ok, _index_live, html} = live(conn, ~p"/links")

      assert html =~ "Listing Links"
      assert html =~ link.original_url
    end

    test "saves new link", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/links")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Link")
               |> render_click()
               |> follow_redirect(conn, ~p"/links/new")

      assert render(form_live) =~ "New Link"

      assert form_live
             |> form("#link-form", link: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#link-form", link: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/links")

      html = render(index_live)
      assert html =~ "Link created successfully"
      assert html =~ "some original_url"
    end

    test "updates link in listing", %{conn: conn, link: link} do
      {:ok, index_live, _html} = live(conn, ~p"/links")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#links-#{link.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/links/#{link}/edit")

      assert render(form_live) =~ "Edit Link"

      assert form_live
             |> form("#link-form", link: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#link-form", link: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/links")

      html = render(index_live)
      assert html =~ "Link updated successfully"
      assert html =~ "some updated original_url"
    end

    test "deletes link in listing", %{conn: conn, link: link} do
      {:ok, index_live, _html} = live(conn, ~p"/links")

      assert index_live |> element("#links-#{link.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#links-#{link.id}")
    end
  end

  describe "Show" do
    setup [:create_link]

    test "displays link", %{conn: conn, link: link} do
      {:ok, _show_live, html} = live(conn, ~p"/links/#{link}")

      assert html =~ "Show Link"
      assert html =~ link.original_url
    end

    test "updates link and returns to show", %{conn: conn, link: link} do
      {:ok, show_live, _html} = live(conn, ~p"/links/#{link}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/links/#{link}/edit?return_to=show")

      assert render(form_live) =~ "Edit Link"

      assert form_live
             |> form("#link-form", link: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#link-form", link: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/links/#{link}")

      html = render(show_live)
      assert html =~ "Link updated successfully"
      assert html =~ "some updated original_url"
    end
  end
end
