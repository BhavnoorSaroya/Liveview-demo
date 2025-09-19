defmodule QuizLiveWeb.QuestionLive.Index do
  use QuizLiveWeb, :live_view

    # @quiz_live_web_admin_path "/admin"

  alias QuizLive.Quizzes

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Listing Questions
        <:actions>
          <.button variant="primary" navigate={~p"/admin/questions/new"}>
            <.icon name="hero-plus" /> New Question
          </.button>
        </:actions>
      </.header>

      <.table
        id="questions"
        rows={@streams.questions}
        row_click={fn {_id, question} -> JS.navigate(~p"/admin/questions/#{question}") end}
      >
        <:col :let={{_id, question}} label="Text">{question.text}</:col>
<:col :let={{_id, question}} label="Active">
  <%= if question.active do %>
    <span class="px-2 py-1 rounded-full text-xs font-semibold bg-green-100 text-green-800">
      Active
    </span>
  <% else %>
    <span class="px-2 py-1 rounded-full text-xs font-semibold bg-gray-100 text-gray-600">
      Inactive
    </span>
  <% end %>
</:col>

<:col :let={{_id, question}} label="Answer published">
  <%= if question.answer_published do %>
    <span class="px-2 py-1 rounded-full text-xs font-semibold bg-blue-100 text-blue-800">
      Published
    </span>
  <% else %>
    <span class="px-2 py-1 rounded-full text-xs font-semibold bg-yellow-100 text-yellow-800">
      Pending
    </span>
  <% end %>
</:col>

        <:action :let={{_id, question}}>
          <div class="sr-only">
            <.link navigate={~p"/admin/questions/#{question}"}>Show</.link>
          </div>
          <.link navigate={~p"/admin/questions/#{question}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, question}}>
          <.link
            phx-click={JS.push("delete", value: %{id: question.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>

         <!-- 🔽 Add this new block -->
        <:action :let={{_id, question}}>
          <.button phx-click="set_active" phx-value-id={question.id} size="sm">
            Set Active
          </.button>
          <.button phx-click="publish_answer" phx-value-id={question.id} size="sm">
            Publish Answer
          </.button>
        </:action>


      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Listing Questions")
     |> stream(:questions, list_questions())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    question = Quizzes.get_question!(id)
    {:ok, _} = Quizzes.delete_question(question)

    {:noreply, stream_delete(socket, :questions, question)}
  end

  defp list_questions() do
    Quizzes.list_questions()
  end



  @impl true
  def handle_event("set_active", %{"id" => id}, socket) do
    id = String.to_integer(id)
    question = Quizzes.get_question_with_answers!(id)
    {:ok, _q} = Quizzes.set_active_question(question)
    {:noreply, socket}
  end

  @impl true
  def handle_event("publish_answer", %{"id" => id}, socket) do
    id = String.to_integer(id)
    question = Quizzes.get_question_with_answers!(id)
    Quizzes.publish_answer(question)
    {:noreply, socket}
  end
end
