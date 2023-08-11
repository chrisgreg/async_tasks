defmodule AsyncTasks.Repo do
  use Ecto.Repo,
    otp_app: :async_tasks,
    adapter: Ecto.Adapters.Postgres
end
