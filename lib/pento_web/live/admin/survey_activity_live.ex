defmodule PentoWeb.SurveyActivityLive do
    use PentoWeb, :live_component
    alias PentoWeb.Presence

    def update(_assigns, socket) do
      {:ok,
        socket
        |> assign_survey_activity()}
    end

    def assign_survey_activity(socket) do
      taking_surveys = Presence.list_users_taking_surveys()
      IO.puts "AT ASSIGN:"
      IO.inspect taking_surveys
      assign(socket, :survey_activity, taking_surveys)
    end
end
