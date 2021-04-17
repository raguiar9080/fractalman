defmodule GurrenWeb.Router do
  use GurrenWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    # resources "/users", UserController
    # resources "/sessions", SessionController, only: [:index, :show, :delete]
  end

  scope "/", GurrenWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    resources "/users", UserController, only: [:create, :new, :index, :show, :edit, :update, :delete]

    resources "/sessions", SessionController, only: [:index, :show, :edit, :update, :delete]
    get "/sign-in", SessionController, :new
    post "/sign-in", SessionController, :create
  end

  # Other scopes may use custom stacks.
  # scope "/api", GurrenWeb do
  #   pipe_through :api
  # end
end
