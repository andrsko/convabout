defmodule ConvaboutWeb.Router do
  use ConvaboutWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :auth do
    plug(Convabout.Accounts.Pipeline)
  end

  pipeline :ensure_auth do
    plug(Guardian.Plug.EnsureAuthenticated)
  end

  scope "/", ConvaboutWeb do
    pipe_through([:api, :auth])
    resources("/chat", ChatController, only: [:show])
    resources("/posts", PostController, only: [:index, :show])
    post("/sign_up", AuthController, :sign_up)
    post("/sign_in", AuthController, :sign_in)
    get("/trending_tags", TagController, :trending)
    get("/posts_of_tag/:id", PostController, :posts_of_tag)
    get("/posts_of_tag_name/:name", PostController, :posts_of_tag_name)
  end

  scope "/", ConvaboutWeb do
    pipe_through([:api, :auth, :ensure_auth])
    post("/posts", PostController, :create)
    post("/set_password", AuthController, :set_password)
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through([:fetch_session, :protect_from_forgery])
      live_dashboard("/dashboard", metrics: ConvaboutWeb.Telemetry)
    end
  end
end
