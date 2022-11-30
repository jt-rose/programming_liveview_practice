# defmodule PentoWeb.SurveyLive do
#   use PentoWeb, :live_view
#   #alias __MODULE__.Component
#   import __MODULE__.Component
#   alias Pento.Survey
#   alias PentoWeb.DemographicLive
#   # alias PentoWeb.DemographicLive.Form

#   def inner(assigns) do
#     ~H"""
#     <h3>I'm an inner component that says: <%= @stuff %></h3>
#     """
#   end

#   defp assign_demographic(%{assigns: %{current_user: current_user}} = socket) do
#     assign(socket,
#     :demographic,
#     Survey.get_demographic_by_user(current_user))
#   end

# # user struct will already be added to socket via UserAuthLive
#   def mount(_params, _session, socket) do
#     IO.puts "PARENT SELF:"
#     IO.inspect self()
#     {:ok, socket
#   |> assign_demographic()}
#   end

#   def handle_info({:check, msg}, socket) do
#     IO.puts msg
#     {:noreply, socket}
#   end

#   def handle_info({:demo, demographic}, socket) do
#     IO.puts "HANDLE INFO FOR CREATED DEMO RECIEVED"
#     {:noreply, handle_demographic_created(socket, demographic)}
#   end

#   def handle_demographic_created(socket, demographic) do
#     IO.puts "FLASH MESSAGE AND ASSIGN DEMOGRAPHIC"
#     socket
#     |> put_flash(:info, "Demographic created successfully")
#     |> assign(:demographic, demographic)
#   end

# end



defmodule PentoWeb.SurveyLive do
  use PentoWeb, :live_view
  alias Pento.{Survey, Catalog}
  alias PentoWeb.{DemographicLive, RatingLive, Endpoint}
  alias PentoWeb.Presence

  @survey_results_topic "survey_results"

  @impl true
  def mount(_params, _session, socket) do

    maybe_track_user(socket)

    updated_socket = socket
    |> assign_demographic()
    |> assign_products()

    {:ok, updated_socket}
  end

@impl true
  def handle_info({:created_demographic, demographic}, socket) do
    {:noreply, handle_demographic_created(socket, demographic)}
  end

# @impl true
#   def handle_info({:created_rating, updated_product, product_index}, socket) do
#     {:noreply, handle_rating_created(socket, updated_product, product_index)}
#   end

  def handle_info({:created_rating, updated_product, product_index}, socket) do
    IO.puts "handle rating recieved"
    {:noreply, handle_rating_created(socket, updated_product, product_index)}
  end

  # def handle_rating_created(%{ assigns: %{products: products}} = socket, updated_product, product_index) do
  #   socket
  #   |> put_flash(:info, "Rating submitted successfully")
  #   |> assign(:products, List.replace_at(products, product_index, updated_product))
  # end

  def assign_products(%{assigns: %{current_user: current_user}} = socket) do
    products = Catalog.list_products_with_user_rating(current_user)
    assign(socket, :products, products)
  end

  # defp list_products(user) do
  #   Catalog.list_products_with_user_rating(user)
  # end

  def handle_demographic_created(socket, demographic) do
    socket
    |> put_flash(:info, "Demographic created successfully")
    |> assign(:demographic, demographic)
  end

  def handle_rating_created(
         %{assigns: %{products: products}} = socket,
         updated_product,
         product_index
       ) do
    Endpoint.broadcast(@survey_results_topic, "rating_created", %{})
    IO.puts "RATING CREATED MESSAGE BROADCAST"


    socket
    |> put_flash(:info, "Rating submitted successfully")
    |> assign(
      :products,
      List.replace_at(products, product_index, updated_product)
    )
  end

  def assign_demographic(%{assigns: %{current_user: current_user}} = socket) do
    assign(socket,
      :demographic,
      Survey.get_demographic_by_user(current_user))
  end

  def maybe_track_user(socket) do
    if connected?(socket) do
      Presence.track_user_survey(self(), socket.assigns.current_user.email)
    end
  end

end
