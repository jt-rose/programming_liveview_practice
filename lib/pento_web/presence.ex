defmodule PentoWeb.Presence do
  use Phoenix.Presence,
  otp_app: :pento,
  pubsub_server: Pento.PubSub

  alias PentoWeb.Presence
  alias Pento.Accounts
  @user_activity_topic "user_activity"
  @survey_activity_topic "survey_activity"

  def track_user(pid, product, user_email) do
    Presence.track(pid, @user_activity_topic, product.name, %{ users: [%{email: user_email}]})
  end

  def track_user_survey(pid, user_email) do
    Presence.track(pid, @survey_activity_topic, :survey_activity, %{ users: [%{email: user_email}]})
  end

  def list_products_and_users do
    Presence.list(@user_activity_topic)
    |> Enum.map(&extract_product_with_users/1)
  end

  defp extract_product_with_users({product_name, %{metas: metas}}) do
    {product_name, users_from_metas_list(metas)}
  end

  defp users_from_metas_list(meta_list) do
    Enum.map(meta_list, &users_from_meta_map/1)
    |> List.flatten()
    |> Enum.uniq()
  end

  def users_from_meta_map(meta_map) do
    get_in(meta_map, [:users])
  end

  def list_users_taking_surveys do
    # IO.puts "PRESENCE-LIST"
    # survey_activity = Presence.list(@survey_activity_topic)["survey_activity"]
    # IO.inspect hd(survey_activity[:metas])[:users]
    # for p <- Presence.list(@survey_activity_topic) do
    #   IO.inspect p
    # end

    Presence.list(@survey_activity_topic)
    |> Enum.map(&extract_users/1)
    |> List.flatten()
    |> Enum.uniq()

  end

  def extract_users({ _s, %{metas: metas}}) do
    users_from_metas_list(metas)
  end

end
