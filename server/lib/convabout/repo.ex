defmodule Convabout.Repo do
  use Ecto.Repo,
    otp_app: :convabout,
    adapter: Ecto.Adapters.Postgres
end
