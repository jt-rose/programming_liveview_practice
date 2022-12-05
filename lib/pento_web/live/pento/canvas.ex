defmodule PentoWeb.Pento.Canvas do
  use Phoenix.Component

  def draw(assigns) do
    ~H"""
      <svg viewBox={ @viewBox }>
        <defs>
          <rect id="point" width="10" height="10" />
        </defs>
        <%= render_slot(@inner_block) %>
      </svg>
    """
  end
end
