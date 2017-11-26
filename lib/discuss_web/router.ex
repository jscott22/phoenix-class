defmodule DiscussWeb.Router do
  use DiscussWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_flash
    plug :fetch_session
  end

  scope "/", DiscussWeb do
    pipe_through :browser # Use the default browser stack

    get "/", TopicController, :index
    get "/topics/new", TopicController, :new
    # post "/topics/new", TopicController, :create
  end

  # Other scopes may use custom stacks.
  scope "/api", DiscussWeb do
    pipe_through :browser
    post "/topics", TopicController, :create
  end
end