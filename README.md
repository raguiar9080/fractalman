# Gurren

Gurren is a small Phoenix Server, made to learn and explore Elixir.
It provides Authentication and messaging via channels (JS websockets).
As of now, it provides a small page where it's possible to stream
microphone audio to the server, which is broadcasted to clients.

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

