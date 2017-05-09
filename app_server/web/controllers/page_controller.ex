defmodule AppServer.PageController do
  use AppServer.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
