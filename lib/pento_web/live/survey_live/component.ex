defmodule PentoWeb.SurveyLive.Component do
  use Phoenix.Component

  def hero(assigns) do
    ~H"""
    <h2>
      content: <%=  @content%>
    </h2>
    <h3>
      slot: <%= render_slot(@inner_block) %>
    </h3>
    """
  end

  def custom_list(assigns) do
    ~H"""
    <ul>
    <%= for item <- @items do %>
    <li><%= item %></li>
    <% end %>
    </ul>
    """
  end
end
