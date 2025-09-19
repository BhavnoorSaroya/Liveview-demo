defmodule QuizLiveWeb.AnswerLive.Index do
  use QuizLiveWeb, :live_view

  alias QuizLive.Quizzes

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Listing Answers
        <:actions>
          <.button variant="primary" navigate={~p"/answers/new"}>
            <.icon name="hero-plus" /> New Answer
          </.button>
        </:actions>
      </.header>

      <.table
        id="answers"
        rows={@streams.answers}
        row_click={fn {_id, answer} -> JS.navigate(~p"/answers/#{answer}") end}
      >
        <:col :let={{_id, answer}} label="Text">{answer.text}</:col>
        <:col :let={{_id, answer}} label="Correct">{answer.correct}</:col>
        <:action :let={{_id, answer}}>
          <div class="sr-only">
            <.link navigate={~p"/answers/#{answer}"}>Show</.link>
          </div>
          <.link navigate={~p"/answers/#{answer}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, answer}}>
          <.link
            phx-click={JS.push("delete", value: %{id: answer.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Listing Answers")
     |> stream(:answers, list_answers())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    answer = Quizzes.get_answer!(id)
    {:ok, _} = Quizzes.delete_answer(answer)

    {:noreply, stream_delete(socket, :answers, answer)}
  end

  defp list_answers() do
    Quizzes.list_answers()
  end
end
