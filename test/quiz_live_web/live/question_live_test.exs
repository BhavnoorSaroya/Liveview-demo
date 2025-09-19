defmodule QuizLiveWeb.QuestionLiveTest do
  use QuizLiveWeb.ConnCase

  import Phoenix.LiveViewTest
  import QuizLive.QuizzesFixtures

  @create_attrs %{active: true, text: "some text", answer_published: true}
  @update_attrs %{active: false, text: "some updated text", answer_published: false}
  @invalid_attrs %{active: false, text: nil, answer_published: false}
  defp create_question(_) do
    question = question_fixture()

    %{question: question}
  end

  describe "Index" do
    setup [:create_question]

    test "lists all questions", %{conn: conn, question: question} do
      {:ok, _index_live, html} = live(conn, ~p"/admin/questions")

      assert html =~ "Listing Questions"
      assert html =~ question.text
    end

    test "saves new question", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/admin/questions")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Question")
               |> render_click()
               |> follow_redirect(conn, ~p"/admin/questions/new")

      assert render(form_live) =~ "New Question"

      assert form_live
             |> form("#question-form", question: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#question-form", question: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/admin/questions")

      html = render(index_live)
      assert html =~ "Question created successfully"
      assert html =~ "some text"
    end

    test "updates question in listing", %{conn: conn, question: question} do
      {:ok, index_live, _html} = live(conn, ~p"/admin/questions")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#questions-#{question.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/admin/questions/#{question}/edit")

      assert render(form_live) =~ "Edit Question"

      assert form_live
             |> form("#question-form", question: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#question-form", question: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/admin/questions")

      html = render(index_live)
      assert html =~ "Question updated successfully"
      assert html =~ "some updated text"
    end

    test "deletes question in listing", %{conn: conn, question: question} do
      {:ok, index_live, _html} = live(conn, ~p"/admin/questions")

      assert index_live |> element("#questions-#{question.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#questions-#{question.id}")
    end
  end

  describe "Show" do
    setup [:create_question]

    test "displays question", %{conn: conn, question: question} do
      {:ok, _show_live, html} = live(conn, ~p"/admin/questions/#{question}")

      assert html =~ "Show Question"
      assert html =~ question.text
    end

    test "updates question and returns to show", %{conn: conn, question: question} do
      {:ok, show_live, _html} = live(conn, ~p"/admin/questions/#{question}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/admin/questions/#{question}/edit?return_to=show")

      assert render(form_live) =~ "Edit Question"

      assert form_live
             |> form("#question-form", question: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#question-form", question: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/admin/questions/#{question}")

      html = render(show_live)
      assert html =~ "Question updated successfully"
      assert html =~ "some updated text"
    end
  end
end
