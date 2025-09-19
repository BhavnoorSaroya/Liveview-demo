defmodule QuizLive.QuizzesTest do
  use QuizLive.DataCase

  alias QuizLive.Quizzes

  describe "questions" do
    alias QuizLive.Quizzes.Question

    import QuizLive.QuizzesFixtures

    @invalid_attrs %{active: nil, text: nil, answer_published: nil}

    test "list_questions/0 returns all questions" do
      question = question_fixture()
      assert Quizzes.list_questions() == [question]
    end

    test "get_question!/1 returns the question with given id" do
      question = question_fixture()
      assert Quizzes.get_question!(question.id) == question
    end

    test "create_question/1 with valid data creates a question" do
      valid_attrs = %{active: true, text: "some text", answer_published: true}

      assert {:ok, %Question{} = question} = Quizzes.create_question(valid_attrs)
      assert question.active == true
      assert question.text == "some text"
      assert question.answer_published == true
    end

    test "create_question/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Quizzes.create_question(@invalid_attrs)
    end

    test "update_question/2 with valid data updates the question" do
      question = question_fixture()
      update_attrs = %{active: false, text: "some updated text", answer_published: false}

      assert {:ok, %Question{} = question} = Quizzes.update_question(question, update_attrs)
      assert question.active == false
      assert question.text == "some updated text"
      assert question.answer_published == false
    end

    test "update_question/2 with invalid data returns error changeset" do
      question = question_fixture()
      assert {:error, %Ecto.Changeset{}} = Quizzes.update_question(question, @invalid_attrs)
      assert question == Quizzes.get_question!(question.id)
    end

    test "delete_question/1 deletes the question" do
      question = question_fixture()
      assert {:ok, %Question{}} = Quizzes.delete_question(question)
      assert_raise Ecto.NoResultsError, fn -> Quizzes.get_question!(question.id) end
    end

    test "change_question/1 returns a question changeset" do
      question = question_fixture()
      assert %Ecto.Changeset{} = Quizzes.change_question(question)
    end
  end

  describe "answers" do
    alias QuizLive.Quizzes.Answer

    import QuizLive.QuizzesFixtures

    @invalid_attrs %{text: nil, correct: nil}

    test "list_answers/0 returns all answers" do
      answer = answer_fixture()
      assert Quizzes.list_answers() == [answer]
    end

    test "get_answer!/1 returns the answer with given id" do
      answer = answer_fixture()
      assert Quizzes.get_answer!(answer.id) == answer
    end

    test "create_answer/1 with valid data creates a answer" do
      valid_attrs = %{text: "some text", correct: true}

      assert {:ok, %Answer{} = answer} = Quizzes.create_answer(valid_attrs)
      assert answer.text == "some text"
      assert answer.correct == true
    end

    test "create_answer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Quizzes.create_answer(@invalid_attrs)
    end

    test "update_answer/2 with valid data updates the answer" do
      answer = answer_fixture()
      update_attrs = %{text: "some updated text", correct: false}

      assert {:ok, %Answer{} = answer} = Quizzes.update_answer(answer, update_attrs)
      assert answer.text == "some updated text"
      assert answer.correct == false
    end

    test "update_answer/2 with invalid data returns error changeset" do
      answer = answer_fixture()
      assert {:error, %Ecto.Changeset{}} = Quizzes.update_answer(answer, @invalid_attrs)
      assert answer == Quizzes.get_answer!(answer.id)
    end

    test "delete_answer/1 deletes the answer" do
      answer = answer_fixture()
      assert {:ok, %Answer{}} = Quizzes.delete_answer(answer)
      assert_raise Ecto.NoResultsError, fn -> Quizzes.get_answer!(answer.id) end
    end

    test "change_answer/1 returns a answer changeset" do
      answer = answer_fixture()
      assert %Ecto.Changeset{} = Quizzes.change_answer(answer)
    end
  end
end
