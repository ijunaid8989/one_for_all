defmodule EverdeployWeb.StartupLive do
  use EverdeployWeb, :live_view
  alias Everdeploy.Accounts
  alias Everdeploy.Accounts.User

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, %{changeset: Accounts.change_user(%User{})})}
  end

  def handle_event("validate", %{"user" => user} = params, socket) do
    changeset =
      %User{}
      |> Accounts.change_user(user)
      |> Map.put(:action, :insert)
      |> IO.inspect

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"user" => user} = params, socket) do
    IO.inspect params
    case Accounts.create_user(user) do
      {:ok, user} ->
        {:noreply,
         socket
         |> put_flash(:info, "user created")
         |> redirect(to: Routes.user_path(MyAppWeb.Endpoint, MyAppWeb.User.ShowView, user))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
