defmodule PentoWeb.Pento.Palette do
  use Phoenix.Component
  alias PentoWeb.Pento.{Shape, Canvas}
  alias Pento.Game.Pentomino
  import PentoWeb.Pento.Colors

  def draw(%{shape_names: shape_names} = assigns) do
    shapes =
      shape_names
      |> Enum.with_index
      |> Enum.map(&pentomino/1)

    assigns = assign(assigns, shapes: shapes)
    ~H"""
      <div id="palette">
        <Canvas.draw viewBox="0 0 500 125">
        <%= for shape <- @shapes do %>
          <Shape.draw
          points={ shape.points }
          fill={ color(shape.color)}
          name={ shape.name } />
        <% end %>
        </Canvas.draw>
      </div>
    """
  end

  defp pentomino({name, i}) do
    {x, y} = {rem(i, 6) * 4 + 3, div(i, 6) * 5 + 3}
    Pentomino.new(name: name, location: {x, y})
    |> Pentomino.to_shape
  end
end
