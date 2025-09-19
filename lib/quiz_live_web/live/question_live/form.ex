defmodule QuizLiveWeb.QuestionLive.Form do

  use QuizLiveWeb, :live_view

  alias QuizLive.Quizzes
  alias QuizLive.Quizzes.{Question, Answer}

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage question records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="question-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:text]} type="textarea" label="Question Text" />
        <.input field={@form[:active]} type="checkbox" label="Active" />
        <.input field={@form[:answer_published]} type="checkbox" label="Answer published" />

        <h3 class="mt-6 mb-2 font-semibold">Answers</h3>

        <.inputs_for :let={f} field={@form[:answers]}>
  <div class="mb-4 border rounded p-3">
    <.input field={f[:text]} type="text" label="Answer Text" />
    <.input field={f[:correct]} type="checkbox" label="Correct?" />
  </div>
</.inputs_for>



        <footer class="mt-6 flex gap-2">
          <.button phx-disable-with="Saving..." variant="primary">Save Question</.button>
          <.button navigate={return_path(@return_to, @question)}>Cancel</.button>
        </footer>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => id}) do
    question = Quizzes.get_question!(id) |> QuizLive.Repo.preload(:answers)

    socket
    |> assign(:page_title, "Edit Question")
    |> assign(:question, question)
    |> assign(:form, to_form(Quizzes.change_question(question)))
  end

  defp apply_action(socket, :new, _params) do
    # Build a new question with 3 empty answers
    question = %Question{
      answers: [
        %Answer{},
        %Answer{},
        %Answer{}
      ]
    }

    socket
    |> assign(:page_title, "New Question")
    |> assign(:question, question)
    |> assign(:form, to_form(Quizzes.change_question(question)))
  end

  @impl true
  def handle_event("validate", %{"question" => question_params}, socket) do
    changeset = Quizzes.change_question(socket.assigns.question, question_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"question" => question_params}, socket) do
    save_question(socket, socket.assigns.live_action, question_params)
  end

  defp save_question(socket, :edit, question_params) do
    case Quizzes.update_question(socket.assigns.question, question_params) do
      {:ok, question} ->
        {:noreply,
         socket
         |> put_flash(:info, "Question updated successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, question))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_question(socket, :new, question_params) do
    case Quizzes.create_question(question_params) do
      {:ok, question} ->
        {:noreply,
         socket
         |> put_flash(:info, "Question created successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, question))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path("index", _question), do: ~p"/admin/questions"
  defp return_path("show", question), do: ~p"/admin/questions/#{question}"
end
