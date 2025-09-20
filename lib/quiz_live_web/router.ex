defmodule QuizLiveWeb.Router do
  use QuizLiveWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {QuizLiveWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", QuizLiveWeb do
    pipe_through :browser

    get "/", PageController, :home
  end


  scope "/admin", QuizLiveWeb do
    pipe_through :browser

    live "/questions", QuestionLive.Index, :index
    live "/questions/new", QuestionLive.Form, :new
    live "/questions/:id", QuestionLive.Show, :show
    live "/questions/:id/edit", QuestionLive.Form, :edit


    live "/answers", AnswerLive.Index, :index
    live "/answers/new", AnswerLive.Form, :new
    live "/answers/:id", AnswerLive.Show, :show
    live "/answers/:id/edit", AnswerLive.Form, :edit
  end

  scope "/", QuizLiveWeb do
    pipe_through :browser

    live "/quiz", QuizLive, :index
    live "/quiz_retro", QuizLiveRetro, :index
  end



  # Other scopes may use custom stacks.
  # scope "/api", QuizLiveWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:quiz_live, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: QuizLiveWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
