defmodule QuizLiveWeb.QuestionLive.Show do
  use QuizLiveWeb, :live_view

  alias QuizLive.Quizzes

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Question {@question.id}
        <:subtitle>This is a question record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/admin/questions"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/admin/questions/#{@question}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit question
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Text">{@question.text}</:item>
        <:item title="Active">{@question.active}</:item>
        <:item title="Answer published">{@question.answer_published}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Question")
     |> assign(:question, Quizzes.get_question!(id))}
  end
end
