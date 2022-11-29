defmodule PentoWeb.ProductLive.Show do
  use PentoWeb, :live_view
  alias PentoWeb.Presence
  alias Pento.Accounts
  alias Pento.Catalog

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    product = Catalog.get_product!(id)
    maybe_track_user(product, socket)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:product, product)}
  end

  defp page_title(:show), do: "Show Product"
  defp page_title(:edit), do: "Edit Product"

  def maybe_track_user(product, socket) do
    if connected?(socket) do
      Presence.track_user(self(), product, socket.assigns.current_user.email)
    end
  end

  def maybe_track_user(product, socket), do: nil
end
