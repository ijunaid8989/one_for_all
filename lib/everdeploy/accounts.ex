defmodule Everdeploy.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Everdeploy.Repo

  alias Everdeploy.Accounts.User

  def get_user!(id), do: Repo.get!(User, id)

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert_or_update()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  def check_user_creds(attrs) do
    Repo.get_by(User, email: attrs["email"])
    |> case do
      nil -> "not_found"
      user ->
        case password_match?(attrs["password"], user) do
          false -> false
          true -> user
        end
    end
  end

  defp password_match?(password, user) do
    Bcrypt.verify_pass(password, user.password)
  end
end
