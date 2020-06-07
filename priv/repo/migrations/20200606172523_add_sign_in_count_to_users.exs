defmodule Everdeploy.Repo.Migrations.AddSignInCountToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :sign_in_count, :integer
    end
  end
end
