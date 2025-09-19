defmodule QuizLive.Repo do
  use Ecto.Repo,
    otp_app: :quiz_live,
    adapter: Ecto.Adapters.SQLite3
end
