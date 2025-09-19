# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     QuizLive.Repo.insert!(%QuizLive.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias QuizLive.Repo
alias QuizLive.Quizzes.{Question, Answer}

q1 = %Question{text: "What color is the sky?", active: false, answer_published: false} |> Repo.insert!()
[
  %Answer{question_id: q1.id, text: "Blue", correct: true},
  %Answer{question_id: q1.id, text: "Green", correct: false},
  %Answer{question_id: q1.id, text: "Red", correct: false}
]
|> Enum.each(&Repo.insert!/1)

q2 = %Question{text: "2 + 2 = ?", active: false, answer_published: false} |> Repo.insert!()
[
  %Answer{question_id: q2.id, text: "3", correct: false},
  %Answer{question_id: q2.id, text: "4", correct: true},
  %Answer{question_id: q2.id, text: "5", correct: false}
]
|> Enum.each(&Repo.insert!/1)
