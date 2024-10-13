defmodule TodoAppWeb.Router do
  use TodoAppWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {TodoAppWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TodoAppWeb do
    pipe_through :browser

    # Set the root path to the Todos index page
    live "/", TodoLive.Index, :index

    # LiveView routes for the Todo resource
    live "/todos", TodoLive.Index, :index
    live "/todos/new", TodoLive.Index, :new
    live "/todos/:id/edit", TodoLive.Index, :edit

    live "/todos/:id", TodoLive.Show, :show
    live "/todos/:id/show/edit", TodoLive.Show, :edit

    # If you want to keep the original home page, uncomment the next line
    # get "/", PageController, :home
  end

  # Other scopes may use custom stacks.
  # scope "/api", TodoAppWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:todo_app, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: TodoAppWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
