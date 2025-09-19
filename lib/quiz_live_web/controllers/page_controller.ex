defmodule QuizLiveWeb.PageController do
  use QuizLiveWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
