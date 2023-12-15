defmodule RssSubscriptionBotWeb.Router do
  use RssSubscriptionBotWeb, :router

  import RssSubscriptionBotWeb.Auth, only: [put_account: 2, redirect_if_authenticated: 2]

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:put_account)
    plug(:fetch_live_flash)
    plug(:put_root_layout, html: {RssSubscriptionBotWeb.Layouts, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", RssSubscriptionBotWeb do
    pipe_through(:browser)

    get("/", PageController, :home)
    post("/user/login", UserSessionController, :create)
  end

  scope "/", RssSubscriptionBotWeb do
    pipe_through([:browser, :redirect_if_authenticated])

    live("/user/registration", RegistrationLive)
    live("/user/login", UserLoginLive)
  end

  # Other scopes may use custom stacks.
  # scope "/api", RssSubscriptionBotWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:rss_subscription_bot_web, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through(:browser)

      live_dashboard("/dashboard", metrics: RssSubscriptionBotWeb.Telemetry)
      forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end
  end
end
