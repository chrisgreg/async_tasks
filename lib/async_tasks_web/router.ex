defmodule AsyncTasksWeb.Router do
  alias AsyncTasksWeb.DbBackedLive
  use AsyncTasksWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {AsyncTasksWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AsyncTasksWeb do
    pipe_through :browser

    live "/", HomeLive, :home
    live "/demos/no-optimisation", NoOptimisationLive, :no_optimisation
    live "/demos/loading", LoadingLive, :loading
    live "/demos/db-backed",  DatabaseLive, :db_backed
    live "/demos/pubsub",  PubSubLive, :pub_sub
    live "/demos/final",  FinalLive, :final
  end

  # Other scopes may use custom stacks.
  # scope "/api", AsyncTasksWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:async_tasks, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: AsyncTasksWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
