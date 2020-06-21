defmodule EverdeployWeb.PageLive do
  use EverdeployWeb, :live_view

  def mount(_params, session, socket) do
    if connected?(socket), do: send(self(), :add_branches)
    {:ok, assign(socket, current_user: session["current_user"], evercam_server_branches: [], loading: true)}
  end

  def handle_info(:add_branches, socket) do
    evercam_server_branches =
      case load_me_from_ets() do
        [] -> load_server_branches()
        found -> found
      end
    load_me_to_ets(evercam_server_branches)
    {:noreply, assign(socket, evercam_server_branches: evercam_server_branches, loading: false)}
  end

  defp load_server_branches() do
    data =
      Github.branches("evercam-server2")
      |> Enum.map(&Github.branch("evercam-server2", &1.branch_name))
    load_me_to_ets(data)
    data
  end

  defp load_me_to_ets(evercam_server_branches) do
    :ets.insert_new(:evercam, {"evercam_server_branches", evercam_server_branches})
  end

  defp load_me_from_ets() do
    :ets.lookup(:evercam, "evercam_server_branches") |> parse_ets_lookup()
  end

  defp parse_ets_lookup([]), do: []
  defp parse_ets_lookup([{"evercam_server_branches", []}]), do: []
  defp parse_ets_lookup([{"evercam_server_branches", evercam_server_branches}]), do: evercam_server_branches
end
