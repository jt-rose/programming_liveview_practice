defmodule PentoWeb.GuessRedirectLive do
  import Phoenix.LiveView

  def on_mount(_, _params, _session, socket) do
    {:halt, redirect(socket, to: "/guess")}
  end
end
