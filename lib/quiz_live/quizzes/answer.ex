defmodule QuizLive.Quizzes.Answer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "answers" do
    field :text, :string
    field :correct, :boolean, default: false
    belongs_to :question, QuizLive.Quizzes.Question

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(answer, attrs) do
    answer
    |> cast(attrs, [:text, :correct])
    |> validate_required([:text])
  end
end
