defmodule Pento.Promo do
  alias Pento.Promo.Recipient

  def change_recipient(%Recipient{} = recipient, attrs \\ %{}) do
    Recipient.changeset(recipient, attrs)
  end

  def send_promo(_receipient, _attrs) do
    # send email to promo recipient, stubbed out
    {:ok, %Recipient{}}
  end

end
