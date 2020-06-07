defmodule Everdeploy.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @email_regex ~r/^[A-Za-z0-9._%+-]+@evercam.io$/

  schema "users" do
    field :email, :string
    field :password, :string
    field :sign_in_count, :integer

    timestamps()
  end

  defp encrypt_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password, hash_password(password))
      _ ->
        changeset
    end
  end

  defp hash_password(password) do
    Bcrypt.hash_pwd_salt(password, [12, true])
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password, :sign_in_count])
    |> unique_constraint(:email, [name: :user_email_unique_index, message: "Email has already been taken."])
    |> validate_required([:email], message: "Email cannot be blank.")
    |> validate_required([:password], message: "Password cannot be blank.")
    |> update_change(:email, &String.downcase/1)
    |> validate_format(:email, @email_regex, [message: "Email format isn't valid!"])
    |> validate_length(:password, [min: 6, message: "Password should be at least 6 character(s)."])
    |> encrypt_password
  end
end
