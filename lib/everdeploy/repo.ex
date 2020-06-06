defmodule Everdeploy.Repo do
  use Ecto.Repo,
    otp_app: :everdeploy,
    adapter: Ecto.Adapters.Postgres
end
