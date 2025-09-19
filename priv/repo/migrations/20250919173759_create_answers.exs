defmodule QuizLive.Repo.Migrations.CreateAnswers do
  use Ecto.Migration

  def change do
    create table(:answers) do
      add :text, :text
      add :correct, :boolean, default: false, null: false
      add :question_id, references(:questions, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:answers, [:question_id])
  end
end
