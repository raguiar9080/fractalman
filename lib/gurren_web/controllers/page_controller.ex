defmodule GurrenWeb.PageController do
  use GurrenWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
