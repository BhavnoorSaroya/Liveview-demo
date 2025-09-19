defmodule QuizLive do
  @moduledoc """
  QuizLive keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
end


defmodule QuizLiveWeb.QuizLive do
  use QuizLiveWeb, :live_view
  alias QuizLive.Quizzes

  @impl true
  def mount(_params, _session, socket) do
    # subscribe to pubsub so client receives admin events
    if connected?(socket), do: Quizzes.subscribe()

    active = Quizzes.get_active_question_with_answers()
    socket =
      assign(socket,
        active_question: active,
        selected_answer_id: nil,
        locked: false,
        published_correct_id: if(active, do: active.answer_published && find_correct_id(active), else: nil)
      )

    {:ok, socket}
  end

  defp find_correct_id(question) do
    (question.answers || [])
    |> Enum.find(fn a -> a.correct end)
    |> case do
      nil -> nil
      a -> a.id
    end
  end

  @impl true
  def handle_event("select_answer", %{"answer-id" => ans_id}, socket) do
    # if already locked, ignore
    if socket.assigns.locked do
      {:noreply, socket}
    else
      ans_id = String.to_integer(ans_id)
      {:noreply, assign(socket, selected_answer_id: ans_id, locked: true)}
    end
  end

  # handle events broadcast by Quizzes
  @impl true
  def handle_info({:active_changed, %{question_id: id}}, socket) do
    # load new active question
    active = Quizzes.get_question_with_answers!(id)
    {:noreply, assign(socket,
      active_question: active,
      selected_answer_id: nil,
      locked: false,
      published_correct_id: nil
    )}
  end

  @impl true
  def handle_info({:answer_published, %{question_id: id, correct_answer_id: correct_id}}, socket) do
    # only update if it's our current active question
    cond do
      socket.assigns.active_question && socket.assigns.active_question.id == id ->
        {:noreply, assign(socket, published_correct_id: correct_id)}

      true ->
        {:noreply, socket}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div id="quiz">
        <%= if @active_question do %>

          <.header><%= @active_question.text %></.header>


          <div class="answers">
            <%= for answer <- @active_question.answers do %>
              <.button
                phx-click="select_answer"
                phx-value-answer-id={answer.id}
                disabled={@locked}
                size="md"
              >
                <%= answer.text %>
              </.button>
            <% end %>
          </div>

          <%= if @published_correct_id do %>
            <div class="result">
              <p>Correct answer: <%= Enum.find(@active_question.answers, &(&1.id == @published_correct_id)).text %></p>
              <p>
                Your selection:
                <%= if @selected_answer_id == @published_correct_id, do: "✅ Correct!", else: "❌ Incorrect" %>
              </p>
            </div>
          <% else %>
            <p class="waiting">Waiting for the host to publish the answer...</p>
          <% end %>

        <% else %>
          <p>No active question right now. Please wait.</p>
        <% end %>
      </div>
    </Layouts.app>
    """
  end
end
