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

  pipeline :auth do
    plug EverdeployWeb.Authenticate
  end

  scope "/", EverdeployWeb do
    pipe_through :browser

    get "/startup", UsersController, :index
    post "/startup", UsersController, :create
    get "/signout", UsersController, :delete
  end

  scope "/v1", EverdeployWeb do
    pipe_through [:browser, :auth]
    
    live "/dashboard", PageLive, :index
  end
end
