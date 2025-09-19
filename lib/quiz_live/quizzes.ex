defmodule QuizLive.Quizzes do
  @moduledoc """
  The Quizzes context.
  """

  import Ecto.Query, warn: false
  alias QuizLive.Repo

  alias QuizLive.Quizzes.Question


  alias QuizLive.Quizzes.{Question, Answer} # from custom here


    # Subscribe for broadcasts about active/published events
  def subscribe do
    Phoenix.PubSub.subscribe(QuizLive.PubSub, "quiz:active")
  end

  defp broadcast(event, payload) do
    Phoenix.PubSub.broadcast(QuizLive.PubSub, "quiz:active", {event, payload})
  end

  # Get the single active question preloaded with answers
  def get_active_question_with_answers do
    Repo.one(from q in Question, where: q.active == true, preload: [:answers])
  end

  def get_question_with_answers!(id) do
    Repo.get!(Question, id) |> Repo.preload(:answers)
  end

  # Set active (atomically): clear existing active, activate the passed question,
  # reset answer_published to false for the newly active question.
  def set_active_question(%Question{} = question) do
    Ecto.Multi.new()
    |> Ecto.Multi.update_all(:deactivate, from(q in Question, where: q.active == true), set: [active: false])
    |> Ecto.Multi.update(:activate_question, Question.changeset(question, %{active: true, answer_published: false}))
    |> Repo.transaction()
    |> case do
      {:ok, %{activate_question: q}} ->
        # broadcast so live views update
        broadcast(:active_changed, %{question_id: q.id})
        {:ok, q}

      {:error, _op, reasons, _changes} ->
        {:error, reasons}
    end
  end

  # Publish the correct answer for a question; broadcast the correct_answer_id
  def publish_answer(%Question{} = question) do
    correct = Repo.one(from a in Answer, where: a.question_id == ^question.id and a.correct == true)

    question
    |> Question.changeset(%{answer_published: true})
    |> Repo.update()
    |> case do
      {:ok, q} ->
        broadcast(:answer_published, %{question_id: q.id, correct_answer_id: if(correct, do: correct.id, else: nil)})
        {:ok, q}

      error ->
        error
    end
  end

  # end custom here


  @doc """
  Returns the list of questions.

  ## Examples

      iex> list_questions()
      [%Question{}, ...]

  """
  def list_questions do
    Repo.all(Question)
  end

  @doc """
  Gets a single question.

  Raises `Ecto.NoResultsError` if the Question does not exist.

  ## Examples

      iex> get_question!(123)
      %Question{}

      iex> get_question!(456)
      ** (Ecto.NoResultsError)

  """
  def get_question!(id), do: Repo.get!(Question, id)

  @doc """
  Creates a question.

  ## Examples

      iex> create_question(%{field: value})
      {:ok, %Question{}}

      iex> create_question(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_question(attrs) do
    %Question{}
    |> Question.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a question.

  ## Examples

      iex> update_question(question, %{field: new_value})
      {:ok, %Question{}}

      iex> update_question(question, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_question(%Question{} = question, attrs) do
    question
    |> Question.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a question.

  ## Examples

      iex> delete_question(question)
      {:ok, %Question{}}

      iex> delete_question(question)
      {:error, %Ecto.Changeset{}}

  """
  def delete_question(%Question{} = question) do
    Repo.delete(question)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking question changes.

  ## Examples

      iex> change_question(question)
      %Ecto.Changeset{data: %Question{}}

  """
  # def change_question(%Question{} = question, attrs \\ %{}) do
  #   Question.changeset(question, attrs)
  # end
def change_question(%Question{} = question, attrs \\ %{}) do
  question
  |> Repo.preload(:answers)   # 👈 ensure answers exist
  |> Question.changeset(attrs)
end

  alias QuizLive.Quizzes.Answer

  @doc """
  Returns the list of answers.

  ## Examples

      iex> list_answers()
      [%Answer{}, ...]

  """
  def list_answers do
    Repo.all(Answer)
  end

  @doc """
  Gets a single answer.

  Raises `Ecto.NoResultsError` if the Answer does not exist.

  ## Examples

      iex> get_answer!(123)
      %Answer{}

      iex> get_answer!(456)
      ** (Ecto.NoResultsError)

  """
  def get_answer!(id), do: Repo.get!(Answer, id)

  @doc """
  Creates a answer.

  ## Examples

      iex> create_answer(%{field: value})
      {:ok, %Answer{}}

      iex> create_answer(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_answer(attrs) do
    %Answer{}
    |> Answer.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a answer.

  ## Examples

      iex> update_answer(answer, %{field: new_value})
      {:ok, %Answer{}}

      iex> update_answer(answer, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_answer(%Answer{} = answer, attrs) do
    answer
    |> Answer.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a answer.

  ## Examples

      iex> delete_answer(answer)
      {:ok, %Answer{}}

      iex> delete_answer(answer)
      {:error, %Ecto.Changeset{}}

  """
  def delete_answer(%Answer{} = answer) do
    Repo.delete(answer)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking answer changes.

  ## Examples

      iex> change_answer(answer)
      %Ecto.Changeset{data: %Answer{}}

  """
  def change_answer(%Answer{} = answer, attrs \\ %{}) do
    Answer.changeset(answer, attrs)
  end
end
