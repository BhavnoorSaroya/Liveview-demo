defmodule QuizLiveWeb.AnswerLive.Show do
  use QuizLiveWeb, :live_view

  alias QuizLive.Quizzes

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Answer {@answer.id}
        <:subtitle>This is a answer record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/answers"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/answers/#{@answer}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit answer
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Text">{@answer.text}</:item>
        <:item title="Correct">{@answer.correct}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Answer")
     |> assign(:answer, Quizzes.get_answer!(id))}
  end
end
