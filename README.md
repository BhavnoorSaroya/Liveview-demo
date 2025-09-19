# QuizLive

To start your Phoenix server:

# 1. Clone the repo
`cd Liveview-demo`

# 2. Install Elixir deps
mix deps.get

# 3. No need to do this one Install JS deps (assets)
cd assets && npm install && cd ..

# 4. Create + migrate database 
// this will setup sqlite db
`mix ecto.create`
`mix ecto.migrate`

# 5. Seed the database with sample questions/answers 
`mix run priv/repo/seeds.exs` // add sample data to db

# 6. Start the Phoenix server
// yaaaaas 
mix phx.server


* Run `mix setup` to install and setup dependencies
* Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

* Official website: https://www.phoenixframework.org/
* Guides: https://hexdocs.pm/phoenix/overview.html
* Docs: https://hexdocs.pm/phoenix
* Forum: https://elixirforum.com/c/phoenix-forum
* Source: https://github.com/phoenixframework/phoenix
