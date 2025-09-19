defmodule QuizLiveWeb.AnswerLiveTest do
  use QuizLiveWeb.ConnCase

  import Phoenix.LiveViewTest
  import QuizLive.QuizzesFixtures

  @create_attrs %{text: "some text", correct: true}
  @update_attrs %{text: "some updated text", correct: false}
  @invalid_attrs %{text: nil, correct: false}
  defp create_answer(_) do
    answer = answer_fixture()

    %{answer: answer}
  end

  describe "Index" do
    setup [:create_answer]

    test "lists all answers", %{conn: conn, answer: answer} do
      {:ok, _index_live, html} = live(conn, ~p"/answers")

      assert html =~ "Listing Answers"
      assert html =~ answer.text
    end

    test "saves new answer", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/answers")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Answer")
               |> render_click()
               |> follow_redirect(conn, ~p"/answers/new")

      assert render(form_live) =~ "New Answer"

      assert form_live
             |> form("#answer-form", answer: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#answer-form", answer: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/answers")

      html = render(index_live)
      assert html =~ "Answer created successfully"
      assert html =~ "some text"
    end

    test "updates answer in listing", %{conn: conn, answer: answer} do
      {:ok, index_live, _html} = live(conn, ~p"/answers")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#answers-#{answer.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/answers/#{answer}/edit")

      assert render(form_live) =~ "Edit Answer"

      assert form_live
             |> form("#answer-form", answer: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#answer-form", answer: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/answers")

      html = render(index_live)
      assert html =~ "Answer updated successfully"
      assert html =~ "some updated text"
    end

    test "deletes answer in listing", %{conn: conn, answer: answer} do
      {:ok, index_live, _html} = live(conn, ~p"/answers")

      assert index_live |> element("#answers-#{answer.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#answers-#{answer.id}")
    end
  end

  describe "Show" do
    setup [:create_answer]

    test "displays answer", %{conn: conn, answer: answer} do
      {:ok, _show_live, html} = live(conn, ~p"/answers/#{answer}")

      assert html =~ "Show Answer"
      assert html =~ answer.text
    end

    test "updates answer and returns to show", %{conn: conn, answer: answer} do
      {:ok, show_live, _html} = live(conn, ~p"/answers/#{answer}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/answers/#{answer}/edit?return_to=show")

      assert render(form_live) =~ "Edit Answer"

      assert form_live
             |> form("#answer-form", answer: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#answer-form", answer: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/answers/#{answer}")

      html = render(show_live)
      assert html =~ "Answer updated successfully"
      assert html =~ "some updated text"
    end
  end
end
