defmodule PentoWeb.WrongLive do
  use Phoenix.LiveView, layout: {PentoWeb.LayoutView, "live.html"}

  alias Pento.Accounts

  def mount(_params, session, socket) do
    {:ok,
     assign(socket,
       score: 0,
       message: "Make a guess:",
       time: time(),
       goal: :rand.uniform(10),
       session_id: session["live_socket_id"]
     )}
  end

  def handle_event("guess", %{"number" => guess} = data, socket) do
    correct = guess == socket.assigns.goal |> to_string()

    message =
      "Your guess: #{guess}. #{if !correct, do: "WRONG!!! Guess Again", else: "BINGO!!! Go again?"}"

    score = if !correct, do: socket.assigns.score - 1, else: socket.assigns.score + 1
    goal = if !correct, do: socket.assigns.goal, else: :rand.uniform(10)
    {:noreply, assign(socket, message: message, score: score, time: time(), goal: goal)}
  end

  def time do
    DateTime.utc_now() |> to_string
  end

  def render(assigns) do
    ~H"""
    <h1>Your Score: <%= @score %></h1>
    <h2><%= @message %></h2>
    <p>it is <%= @time %></p>
    <h2>
    <%= for n <- 1..10 do %>
    <a href="#" phx-click="guess" phx-value-number= {n} ><%= n %></a>
    <% end %>
    <pre>
      <%= @current_user.email %>
      <%= @session_id %>
    </pre>
    </h2>
    """
  end
end
