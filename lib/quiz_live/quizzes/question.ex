defmodule QuizLive.Quizzes.Question do
  use Ecto.Schema
  import Ecto.Changeset

  schema "questions" do
    field :text, :string
    field :active, :boolean, default: false
    field :answer_published, :boolean, default: false

    has_many :answers, QuizLive.Quizzes.Answer, on_replace: :delete

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(question, attrs) do
    question
    |> cast(attrs, [:text, :active, :answer_published])
    |> validate_required([:text])
    |> cast_assoc(:answers, with: &QuizLive.Quizzes.Answer.changeset/2)  # 👈 allow nested answers
  end
end
