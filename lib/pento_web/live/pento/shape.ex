defmodule PentoWeb.Pento.Shape do
  use Phoenix.Component
  alias PentoWeb.Pento.Point

  def draw(assigns) do
    ~H"""
      <%= for {x, y} <- @points do %>
        <Point.draw
        x={ x }
        y={ y }
        fill={ @fill }
        name={ @name } />
      <% end %>
    """
  end
end
