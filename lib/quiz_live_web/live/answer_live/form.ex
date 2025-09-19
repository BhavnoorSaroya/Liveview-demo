defmodule QuizLiveWeb.AnswerLive.Form do
  use QuizLiveWeb, :live_view

  alias QuizLive.Quizzes
  alias QuizLive.Quizzes.Answer

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage answer records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="answer-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:text]} type="textarea" label="Text" />
        <.input field={@form[:correct]} type="checkbox" label="Correct" />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Answer</.button>
          <.button navigate={return_path(@return_to, @answer)}>Cancel</.button>
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
    answer = Quizzes.get_answer!(id)

    socket
    |> assign(:page_title, "Edit Answer")
    |> assign(:answer, answer)
    |> assign(:form, to_form(Quizzes.change_answer(answer)))
  end

  defp apply_action(socket, :new, _params) do
    answer = %Answer{}

    socket
    |> assign(:page_title, "New Answer")
    |> assign(:answer, answer)
    |> assign(:form, to_form(Quizzes.change_answer(answer)))
  end

  @impl true
  def handle_event("validate", %{"answer" => answer_params}, socket) do
    changeset = Quizzes.change_answer(socket.assigns.answer, answer_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"answer" => answer_params}, socket) do
    save_answer(socket, socket.assigns.live_action, answer_params)
  end

  defp save_answer(socket, :edit, answer_params) do
    case Quizzes.update_answer(socket.assigns.answer, answer_params) do
      {:ok, answer} ->
        {:noreply,
         socket
         |> put_flash(:info, "Answer updated successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, answer))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_answer(socket, :new, answer_params) do
    case Quizzes.create_answer(answer_params) do
      {:ok, answer} ->
        {:noreply,
         socket
         |> put_flash(:info, "Answer created successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, answer))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path("index", _answer), do: ~p"/answers"
  defp return_path("show", answer), do: ~p"/answers/#{answer}"
end
