defmodule LiveShowyWeb.ErrorViewTest do
  use LiveShowyWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 404.html" do
    assert render_to_string(LiveShowyWeb.ErrorView, "404.html", []) =~ "not found"
  end

  test "renders 500.html" do
    assert render_to_string(LiveShowyWeb.ErrorView, "500.html", []) =~ "internal"
  end
end
