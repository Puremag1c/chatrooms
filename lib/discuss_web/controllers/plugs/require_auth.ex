defmodule Discuss.Plugs.RequireAuth do
  use DiscussWeb, :controller
  import Plug.Conn
  import Phoenix.Controller

  def init(_params) do

  end

  def call(conn, _params) do
    if conn.assigns[:user] do
      conn
    else
      conn
      |> put_flash(:error, "You must Login")
      |> redirect(to: Routes.topic_path(conn, :index))
      |> halt()
    end
  end
end
