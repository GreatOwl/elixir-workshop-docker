defmodule Workshop.Router do
  use Workshop.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Workshop.CurrentUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Workshop do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    get "/login", SessionController, :new
    post "/login", SessionController, :create
    get "/logout", SessionController, :delete #js errors prevent usage of delete method This is why these view deciscions should not be left up to backenders or framework designers!!!!

    get "/register", RegistrationController, :new
    post "/register", RegistrationController, :create

  end

  # Other scopes may use custom stacks.
  # scope "/api", Workshop do
  #   pipe_through :api
  # end
end
