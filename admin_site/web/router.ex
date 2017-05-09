defmodule AdminSite.Router do
  use AdminSite.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    #plug :protect_from_forgery
    #plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AdminSite do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    post "/start_deploy", PageController, :start_deploy
  end

  # Other scopes may use custom stacks.
  # scope "/api", AdminSite do
  #   pipe_through :api
  # end
end
