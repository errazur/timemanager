defmodule TimemachineWeb.Router do
  use TimemachineWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {TimemachineWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  pipeline :auth do
    plug TimemachineWeb.Plugs.ValidateBearer
    plug :protect_from_forgery # Nota Bene: No CSRF protection on GET requests
  end

  # PUBLIC ROUTES
  scope "/api", TimemachineWeb do
    pipe_through :api

    get "/users", UserController, :search # ?email=XXX&username=YYY
    get "/users/:id", UserController, :show
    post "/login", UserController, :login
  end

  # PROTECTED ROUTES
  scope "/api", TimemachineWeb do
    pipe_through [:api, :auth]

    # MISC
    get "/tokens", UserController, :tokens

    # USERS
    post "/users", UserController, :create
    put "/users/:id", UserController, :update
    delete "/users/:id", UserController, :delete

    # CLOCKS
    get "/clocks/:user_id", ClockController, :index
    post "/clocks/:user_id", ClockController, :create

    # WORKING TIMES
    get "/workingtimes/:user_id", WorkingtimeController, :index
    get "/workingtimes/:user_id/:id", WorkingtimeController, :show
    post "/workingtimes/:user_id", WorkingtimeController, :create
    put "/workingtimes/:id", WorkingtimeController, :update
    delete "/workingtimes/:id", WorkingtimeController, :delete
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:timemachine, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: TimemachineWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
