defmodule PentoWeb.RatingLive.Form do
  use PentoWeb, :live_component
  alias Pento.Survey
  alias Pento.Survey.Rating
  alias PentoWeb.SurveyLive

  def update(assigns, socket) do
    # send(self(), {:check, "heyo"})
    IO.puts "self of component"
    IO.inspect self()
    {:ok,
    socket
    |> assign(assigns)
    |> assign_rating()
    |> assign_changeset()}
  end

  def assign_rating(socket) do
    assign(socket,
      :rating, %Rating{
        user_id: socket.assigns.current_user.id,
        product_id: socket.assigns.product.id})
  end

  def assign_changeset(socket) do
    assign(socket,
      :changeset,
      Survey.change_rating(socket.assigns.rating))
  end

  def handle_event("validate", %{ "rating" => rating_params}, socket) do
    {:noreply, validate_rating(socket, rating_params)}
  end

  def handle_event("save", %{"rating" => rating_params}, socket) do
    {:noreply, save_rating(socket, rating_params)}
  end

  def validate_rating(socket, rating_params) do
    changeset = socket.assigns.rating
      |> Survey.change_rating(rating_params)
      |> Map.put(:action, :validate)

    assign(socket, :changeset, changeset)
  end

  def save_rating(%{ assigns: %{product_index: product_index, product: product}} = socket, rating_params) do
    case Survey.create_rating(rating_params) do
      {:ok, rating} ->
        product = %{product | ratings: [rating]}
        send(self(), {:created_rating, product, product_index})
        IO.puts "handle rating sent"
        socket
      {:error, %Ecto.Changeset{} = changeset} ->
        assign(socket, changeset: changeset)
    end
  end
end
