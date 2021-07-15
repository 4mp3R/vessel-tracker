defmodule VesselTracker.Notifier do
  @moduledoc """
  This module wraps Telegram API library and exposes methods for sending
  notifications about the new vessel location to group chats via Telegram bot.
  """

  alias VesselTracker.VesselInfo

  def send_text(%VesselInfo{vessel_name: vessel_name, from: from, to: to}) do
    {:ok, _} =
      Telegram.Api.request(
        Application.get_env(:vessel_tracker, :telegram_bot_token),
        "sendMessage",
        chat_id: Application.get_env(:vessel_tracker, :telegram_group_chat_id),
        text: "#{vessel_name}: #{from} -> #{to}"
      )
  end

  def send_location(%VesselInfo{lat: lat, lon: lon}) do
    {:ok, _} =
      Telegram.Api.request(
        Application.get_env(:vessel_tracker, :telegram_bot_token),
        "sendlocation",
        chat_id: Application.get_env(:vessel_tracker, :telegram_group_chat_id),
        latitude: lat,
        longitude: lon
      )
  end
end
