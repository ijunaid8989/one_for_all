defmodule EverdeployWeb.DeployLive do
  use EverdeployWeb, :live_view

  def mount(params, session, socket) do
    IO.inspect params
    if connected?(socket), do: send(self(), {:start_deployment, params})
    if connected?(socket), do: :timer.send_interval(1000, self(), :tick)

    {:ok, assign(
      socket,
      current_user: session["current_user"],
      deployment_log:
      "starting"
    )}
  end

  def handle_info({:start_deployment, params}, socket) do
    
    {:noreply, assign(socket, deployment_log: "started")}
  end

  def handle_info(:tick, socket) do
    IO.inspect socket
    IO.inspect "Tick"
    {:noreply, assign(socket, deployment_log: "in progresss")}
  end
end