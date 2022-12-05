defmodule PentoWeb.Pento.Board do
  use PentoWeb, :live_component
  alias PentoWeb.Pento.{Canvas, Palette, Shape}
  alias Pento.Game.{Board, Pentomino}
  alias Pento.Game
  import PentoWeb.Pento.Colors

  def update(%{puzzle: puzzle, id: id}, socket) do
    {:ok,
      socket
      |> assign_params(id, puzzle)
      |> assign_board()
      |> assign_shapes()
    }
  end

  def assign_params(socket, id, puzzle) do
    assign(socket, id: id, puzzle: puzzle)
  end

  def assign_board(%{ assigns: %{ puzzle: puzzle}} = socket) do
    active = Pentomino.new(name: :p, location: {7, 2})
    completed = [
      Pentomino.new(name: :u, rotation: 270, location: {1, 2}),
      Pentomino.new(name: :v, rotation: 90, location: {4, 2})
    ]

    board =
      puzzle
      |> String.to_existing_atom
      |> Board.new
      |> Map.put(:completed_pentos, completed)
      |> Map.put(:active_pento, active)

    assign(socket, board: board)
  end

  def assign_shapes(%{assigns: %{board: board}} = socket) do
    shapes = Board.to_shapes(board)
    assign(socket, shapes: shapes)
  end

  def handle_event("pick", %{"name" => name}, socket) do
    {:noreply, socket |> pick(name) |> assign_shapes}
  end

  def handle_event("key", %{"key" => key}, socket) do
    {:noreply, socket |> do_key(key) |> assign_shapes}
  end

  def do_key(socket, key) do
    case key do
      " " -> drop(socket)
      "ArrowLeft" -> move(socket, :left)
      "ArrowRight" -> move(socket, :right)
      "ArrowUp" -> move(socket, :up)
      "ArrowDown" -> move(socket, :down)
      "Shift" -> move(socket, :rotate)
      "Enter" -> move(socket, :flip)
      "Space" -> drop(socket)
      _ -> socket
    end
  end

  def move(socket, move) do
    case Game.maybe_move(socket.assigns.board, move) do
      {:error, message} ->
        put_flash(socket, :info, message)
      {:ok, board} ->
        socket |> assign(board: board) |> assign_shapes
    end
  end

  defp drop(socket) do
    case Game.maybe_drop(socket.assigns.board) do
      {:error, message} ->
        put_flash(socket, :info, message)
      {:ok, board} ->
        socket |> assign(board: board) |> assign_shapes
    end

  end

  defp pick(socket, name) do
    shape_name = String.to_existing_atom(name)
    update(socket, :board, &Board.pick(&1, shape_name))
  end

  def render(assigns) do
    ~H"""
      <div id={ @id } phx-window-keydown="key" phx-target={ @myself }>
        <Canvas.draw viewBox="0 0 200 70">
          <%= for shape <- @shapes do %>
            <Shape.draw
              points={ shape.points }
              fill= { color(shape.color, Board.active?(@board, shape.name) ) }
              name={ shape.name } />
          <% end %>
        </Canvas.draw>
        <hr/>
        <Palette.draw
          shape_names= { @board.palette }
          id="palette" />
      </div>
    """
  end
end
