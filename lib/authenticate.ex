defmodule EverdeployWeb.Authenticate do
  import Plug.Conn
  import EverdeployWeb.Router.Helpers
  import Phoenix.Controller
 
  def init(_), do: :noop
 
  def call(conn, _) do
    current_user = get_session(conn, :current_user)
    if current_user do
      assign(conn, :current_user, current_user)
    else
      conn
        |> put_flash(:error, 'You need to be signed in to view this page')
        |> redirect(to: "/startup")
    end
  end
end
