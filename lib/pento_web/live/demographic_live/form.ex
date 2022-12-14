# defmodule PentoWeb.DemographicLive.Form do
#   use PentoWeb, :live_component
#   alias Pento.Survey
#   alias Pento.Survey.Demographic

#   def update(assigns, socket) do
#     send(self(), {:check, "hello?"})
#     { :ok, socket
#       |> assign(assigns)
#       |> assign_demographic()
#       |> assign_changeset()
#     }
#   end

#   defp assign_demographic( %{assigns: %{current_user: current_user}} = socket) do
#     assign(socket, :demographic, %Demographic{user_id: current_user.id})
#   end

#   defp assign_changeset(%{assigns: %{demographic: demographic}} = socket) do
#     assign(socket, :changeset, Survey.change_demographic(demographic))
#   end

#   def handle_event("save", %{"demographic" => demographic_params}, socket) do
#     {:noreply, save_demographic(socket, demographic_params)}
#   end

#   defp save_demographic(socket, demographic_params) do
#     case Survey.create_demographic(demographic_params) do
#       {:ok, demographic} ->
#         IO.puts "DEMO SAVED"
#         IO.puts "COMPONENT SELF:"
#         IO.inspect demographic
#         IO.inspect self()
#         send(self(), {:demo, demographic})
#         IO.puts "MESSAGE SENT"
#         socket

#       {:error, %Ecto.Changeset{} = changeset} ->
#         IO.puts "DEMO SAVED_ERROR"
#         assign(socket, changeset: changeset)
#     end
#   end
# end


#---
# Excerpted from "Programming Phoenix LiveView",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit https://pragprog.com/titles/liveview for more book information.
#---
defmodule PentoWeb.DemographicLive.Form do
  use PentoWeb, :live_component
  alias Pento.Survey
  alias Pento.Survey.Demographic

  def update(assigns, socket) do

    {
      :ok,
       assign(socket, :update_demo, "hello")
       |> assign(assigns)
       |> assign_demographic()
       |> assign_changeset()
     }
  end

  defp assign_demographic(
     %{assigns: %{current_user: current_user}} = socket) do
    assign(socket, :demographic, %Demographic{user_id: current_user.id})
  end

  defp assign_changeset(%{assigns: %{demographic: demographic}} = socket) do
    assign(socket, :changeset, Survey.change_demographic(demographic))
  end

  def handle_event("save", %{"demographic" => demographic_params}, socket) do
    {:noreply, save_demographic(socket, demographic_params)}
  end

  def handle_event("validate", %{"demographic" => demographic_params}, socket) do
    {:noreply, validate_demographic(socket, demographic_params)}
  end

  defp save_demographic(socket, demographic_params) do
    case Survey.create_demographic(demographic_params) do
      {:ok, demographic} ->
        send(self(), {:created_demographic, demographic})
        socket

      {:error, %Ecto.Changeset{} = changeset} ->
        assign(socket, changeset: changeset)
    end
  end

  defp validate_demographic(socket, demographic_params) do
    changeset =
      socket.assigns.demographic
      |> Survey.change_demographic(demographic_params)
      |> Map.put(:action, :validate)

    assign(socket, :changeset, changeset)
  end



end
