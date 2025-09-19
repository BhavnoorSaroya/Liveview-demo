defmodule QuizLive.Repo.Migrations.CreateQuestions do
  use Ecto.Migration

  def change do
    create table(:questions) do
      add :text, :text
      add :active, :boolean, default: false, null: false
      add :answer_published, :boolean, default: false, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
