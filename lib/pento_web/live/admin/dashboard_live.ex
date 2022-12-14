defmodule PentoWeb.Admin.DashboardLive do
  use PentoWeb, :live_view
  alias PentoWeb.Endpoint
  @survey_results_topic "survey_results"
  @user_activity_topic "user_activity"
  @survey_activity_topic "survey_activity"

  def handle_info(%{event: "rating_created"}, socket) do
    IO.puts "RATING CREATED MESSAGE RECEIVED"
    send_update(
      PentoWeb.Admin.SurveyResultsLive,
      id: socket.assigns.survey_results_component_id
    )

    {:noreply, socket}
  end

  def handle_info(%{event: "presence_diff"}, socket) do
    send_update(
      PentoWeb.UserActivityLive,
      id: socket.assigns.user_activity_component_id
    )

    send_update(
      PentoWeb.SurveyActivityLive,
      id: socket.assigns.survey_activity_component_id
    )

    {:noreply, socket}
  end

  def mount(_params, _session, socket) do
    if connected?(socket) do
      Endpoint.subscribe(@survey_results_topic)
      Endpoint.subscribe(@user_activity_topic)
      Endpoint.subscribe(@survey_activity_topic)
    end

    {:ok,
    socket
    |> assign(:survey_results_component_id, "survey-results")
    |> assign(:user_activity_component_id, "user-activity")
    |> assign(:survey_activity_component_id, "survey-activity")}
  end

end
