defmodule PentoWeb.UserActivityLive do
  use PentoWeb, :live_component
  alias PentoWeb.Presence

  def update(_assigns, socket) do
    {:ok,
      socket
      |> assign_user_activity()}
  end

  def assign_user_activity(socket) do
    IO.inspect Presence.list_products_and_users()
    assign(socket, :user_activity, Presence.list_products_and_users())
  end
end
