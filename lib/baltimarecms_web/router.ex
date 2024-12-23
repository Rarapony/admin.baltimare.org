defmodule BaltimarecmsWeb.Router do
  use BaltimarecmsWeb, :router

  import BaltimarecmsWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {BaltimarecmsWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BaltimarecmsWeb do
    pipe_through :browser

    get "/", PageController, :home

    resources "/bans", BanController
    resources "/announcements", AnnouncementController
  end

  # Other scopes may use custom stacks.
  # scope "/api", BaltimarecmsWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:baltimarecms, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: BaltimarecmsWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", BaltimarecmsWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{BaltimarecmsWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/login", UserLoginLive, :new
    end


    post "/login", UserSessionController, :send_magic_link
    get "/login/email/token/:token", UserSessionController, :login_with_token
  end

  scope "/", BaltimarecmsWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{BaltimarecmsWeb.UserAuth, :ensure_authenticated}] do
        live "/account", UserSettingsLive, :edit
        live "/account/confirm_email/:token", UserSettingsLive, :confirm_email
    end
  end

  scope "/", BaltimarecmsWeb do
    pipe_through [:browser]

    delete "/logout", UserSessionController, :delete

  end
end
