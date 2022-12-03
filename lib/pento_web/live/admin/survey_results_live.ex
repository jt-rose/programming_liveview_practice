defmodule PentoWeb.Admin.SurveyResultsLive do
  use PentoWeb, :live_component
  use PentoWeb, :chart_live
  alias Pento.Catalog
  alias Contex

  def update(assigns, socket) do
    age_filter = if Map.has_key?(socket.assigns, :age_group_filter), do: socket.assigns.age_group_filter, else: "all"
    gender_filter = if Map.has_key?(socket.assigns, :gender_group_filter), do: socket.assigns.gender_group_filter, else: "all"
    {:ok,
      socket
      |> assign(assigns)
      |> assign_age_group_filter(age_filter)
      |> assign_gender_group_filter(gender_filter)
      |> assign_products_with_average_ratings()
      |> assign_dataset()
      |> assign_chart()
      |> assign_chart_svg()}
  end

  def assign_age_group_filter(socket, age_group_filter) do
    socket
    |> assign(:age_group_filter, age_group_filter)
  end

  def assign_gender_group_filter(socket, gender_group_filter) do
    socket
    |> assign(:gender_group_filter, gender_group_filter)
  end

  defp get_products_with_filters(socket) do
    age_filter = socket.assigns.age_group_filter
    gender_filter = socket.assigns.gender_group_filter
    filter = %{age_group_filter: age_filter, gender_group_filter: gender_filter}

    get_products_with_average_ratings(filter)
  end

  def assign_products_with_average_ratings(socket) do
    result = get_products_with_filters(socket)

    socket
    |> assign(:products_with_average_ratings, result)
  end

  defp get_products_with_average_ratings(filter) do
    case Catalog.products_with_average_ratings(filter) do
      [] -> Catalog.products_with_zero_ratings()
      products -> products
    end
  end

  def assign_dataset(socket) do
    socket
    |> assign(:dataset, make_bar_chart_dataset(socket.assigns.products_with_average_ratings))
  end

  defp assign_chart(socket) do
    socket
    |> assign(:chart, make_bar_chart(socket.assigns.dataset))
  end

  def assign_chart_svg(socket) do
    socket
    |> assign(:chart_svg, render_bar_chart(socket.assigns.chart, title(), subtitle(), x_axis(), y_axis()))
  end

  defp title, do: "Product Ratings"
  defp subtitle, do: "average star ratings per product"
  defp x_axis, do: "products"
  defp y_axis, do: "stars"

  def handle_event("age_group_filter", %{"age_group_filter" => age_group_filter}, socket) do
    {:noreply,
    socket
    |> assign_age_group_filter(age_group_filter)
    |> assign_products_with_average_ratings
    |> assign_dataset()
    |> assign_chart()
    |> assign_chart_svg()}
  end

  def handle_event("gender_group_filter", %{"gender_group_filter" => gender_group_filter}, socket) do
    {:noreply,
    socket
    |> assign_gender_group_filter(gender_group_filter)
    |> assign_products_with_average_ratings
    |> assign_dataset()
    |> assign_chart()
    |> assign_chart_svg()}
  end
end
