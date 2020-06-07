defmodule EverdeployWeb.PageLive do
  use EverdeployWeb, :live_view

  def mount(_params, session, socket) do
    {:ok, assign(socket, current_user: session["current_user"])}
  end
end
