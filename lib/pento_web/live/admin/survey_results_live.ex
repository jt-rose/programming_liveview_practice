defmodule PentoWeb.Admin.SurveyResultsLive do
  use PentoWeb, :live_component
  alias Pento.Catalog
  alias Contex
  alias Contex.Plot

  def update(assigns, socket) do
    {:ok,
      socket
      |> assign(assigns)
      |> assign_products_with_average_ratings()
      |> assign_dataset()
      |> assign_chart()
      |> assign_chart_svg()}
  end

  defp assign_products_with_average_ratings(socket) do
    socket
    |> assign(
      :products_with_average_ratings,
      Catalog.products_with_average_ratings()
    )
  end

  def assign_dataset(socket) do
    socket
    |> assign(:dataset, make_bar_chart_dataset(socket.assigns.products_with_average_ratings))
  end

  defp make_bar_chart_dataset(data) do
    Contex.Dataset.new(data)
  end

  defp assign_chart(socket) do
    socket
    |> assign(:chart, make_bar_chart(socket.assigns.dataset))
  end

  defp make_bar_chart(dataset) do
    Contex.BarChart.new(dataset)
  end

  def assign_chart_svg(socket) do
    socket |> assign(:chart_svg, render_bar_chart(socket.assigns.chart))
  end

  defp render_bar_chart(chart) do
    Plot.new(500, 400, chart)
    |> Plot.titles(title(), subtitle())
    |> Plot.axis_labels(x_axis(), y_axis())
    |> Plot.to_svg()
  end

  defp title, do: "Product Ratings"
  defp subtitle, do: "average star ratings per product"
  defp x_axis, do: "products"
  defp y_axis, do: "stars"
end