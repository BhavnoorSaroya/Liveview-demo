defmodule QuizLive.QuizzesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `QuizLive.Quizzes` context.
  """

  @doc """
  Generate a question.
  """
  def question_fixture(attrs \\ %{}) do
    {:ok, question} =
      attrs
      |> Enum.into(%{
        active: true,
        answer_published: true,
        text: "some text"
      })
      |> QuizLive.Quizzes.create_question()

    question
  end

  @doc """
  Generate a answer.
  """
  def answer_fixture(attrs \\ %{}) do
    {:ok, answer} =
      attrs
      |> Enum.into(%{
        correct: true,
        text: "some text"
      })
      |> QuizLive.Quizzes.create_answer()

    answer
  end
end
