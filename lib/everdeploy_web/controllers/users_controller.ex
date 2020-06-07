defmodule EverdeployWeb.UsersController do
  use EverdeployWeb, :controller

  alias Everdeploy.Accounts
  alias Everdeploy.Accounts.User

  def index(conn, _params) do
    render(conn, "index.html", changeset: Accounts.change_user(%User{}))
  end

  def create(conn, %{"user" => user_params} = params) do
    with "signup" <- params["method"] do
      case Accounts.create_user(user_params) do
        {:ok, user} ->
          conn
          |> put_flash(:info, "Welcome.")
          |> put_session(:current_user, user)
          |> redirect(to: "/")

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "index.html", changeset: changeset)
      end
    else
      _ ->
        case Accounts.change_user(%User{}, user_params) |> Map.put(:action, :update) do
          %Ecto.Changeset{valid?: false} = changeset ->
            render(conn, "index.html", changeset: changeset)
          %Ecto.Changeset{valid?: true} = changeset ->
            Accounts.check_user_creds(user_params)
            |> IO.inspect
            |> case do
              "not_found" -> render(conn, "index.html", changeset: Ecto.Changeset.add_error(changeset, :email, "User not found."))
              false -> render(conn, "index.html", changeset: Ecto.Changeset.add_error(changeset, :password, "Password is not correct."))
              %User{} = user ->
                conn
                |> put_flash(:info, "Welcome.")
                |> put_session(:current_user, user)
                |> redirect(to: "/")
            end
        end
    end

  end
end
