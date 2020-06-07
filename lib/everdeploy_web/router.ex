defmodule EverdeployWeb.Router do
  use EverdeployWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {EverdeployWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", EverdeployWeb do
    pipe_through :browser

    live "/", PageLive, :index
    get "/startup", UsersController, :index
    post "/startup", UsersController, :create
    # live "/startup", StartupLive, :index
    # live "/startin", StartinLive, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", EverdeployWeb do
  #   pipe_through :api
  # end
end
