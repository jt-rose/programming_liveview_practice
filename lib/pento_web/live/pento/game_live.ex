defmodule PentoWeb.Pento.GameLive do
  use PentoWeb, :live_view
  alias PentoWeb.Pento.{ Canvas, Shape, Palette, Board}

  def mount(%{ "puzzle" => puzzle }, _session, socket), do: {:ok, assign(socket, puzzle: puzzle)}

  def render(assigns) do
    ~H"""
    <section class="container">
      <h1>Welcome to Pento!</h1>

      <.live_component module={Board} puzzle={ @puzzle } id="game" />
    </section>
    """
  end
end
