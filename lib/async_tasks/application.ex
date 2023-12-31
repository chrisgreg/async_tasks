defmodule AsyncTasks.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      AsyncTasksWeb.Telemetry,
      # Start the Ecto repository
      AsyncTasks.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: AsyncTasks.PubSub},
      # Start Finch
      {Finch, name: AsyncTasks.Finch},
      # Start the Endpoint (http/https)
      AsyncTasksWeb.Endpoint,
      # Start a worker by calling: AsyncTasks.Worker.start_link(arg)
      {Task.Supervisor, name: AsyncTasks.TaskSupervisor}
      # {AsyncTasks.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AsyncTasks.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AsyncTasksWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
