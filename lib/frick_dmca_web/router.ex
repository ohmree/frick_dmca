defmodule FrickDmcaWeb.Router do
  use FrickDmcaWeb, :router
  use Pow.Phoenix.Router
  use PowAssent.Phoenix.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {FrickDmcaWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :protected do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: Pow.Phoenix.PlugErrorHandler
  end

  pipeline :skip_csrf_protection do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :admin do
    plug FrickDmcaWeb.EnsureRolePlug, :admin
  end

  scope "/", FrickDmcaWeb do
    pipe_through [:browser, :protected]

    live "/", SongLive.Index, :index
    live "/songs", SongLive.Index, :index
    live "/songs/new", SongLive.Index, :new

    live "/songs/:id", SongLive.Show, :show
  end

  scope "/" do
    pipe_through :skip_csrf_protection

    pow_assent_authorization_post_callback_routes()
  end

  scope "/" do
    pipe_through :browser

    # get "/session/new", FrickDmcaWeb.PageController, :
    pow_session_routes()
    pow_assent_routes()
  end

  # Other scopes may use custom stacks.
  # scope "/api", FrickDmcaWeb do
  #   pipe_through :api
  # end

  import Phoenix.LiveDashboard.Router

  scope "/" do
    pipe_through [:browser, :admin]
    live_dashboard "/dashboard", metrics: FrickDmcaWeb.Telemetry
  end
end
