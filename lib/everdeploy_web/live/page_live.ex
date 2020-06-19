defmodule EverdeployWeb.PageLive do
  use EverdeployWeb, :live_view

  def mount(_params, session, socket) do
    if connected?(socket), do: send(self(), :add_branches)
    {:ok, assign(socket, current_user: session["current_user"], evercam_server_branches: [], loading: true)}
  end

  def handle_info(:add_branches, socket) do
    {:noreply, assign(socket, evercam_server_branches: Github.branches("evercam-server2"), loading: false)}
  end
end
