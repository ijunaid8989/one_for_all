defmodule EverdeployWeb.StartupLive do
  use EverdeployWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, query: "")}
  end

  def handle_event("validate", %{"user" => user} = params, socket) do
    {:noreply, assign(socket, changeset: %{})}
  end

  def handle_event("save", %{"user" => user} = params, socket) do
    {:noreply, assign(socket, changeset: %{})}
  end
end
