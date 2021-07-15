defmodule VesselTracker.Checker do
  @moduledoc """
  This module implements a self-invoking recurrent task.
  It scrapes the data about the vessel, compares it to the previously known
  vessel data and sends Telegram notifications if there is a difference.
  """

  alias VesselTracker.{Scraper, Notifier, State}

  use GenServer

  require Logger

  ### Client API

  def start_link() do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  ### Server API

  def init(_state) do
    schedule()

    {:ok, nil}
  end

  def handle_info(:check_vessel_info, _state) do
    schedule()
    check_vessel_info()

    {:noreply, nil}
  end

  def terminate(reason, _state) do
    Logger.critical("Checker process terminated")
    Logger.critical(inspect(reason))
  end

  ### Private functions

  defp schedule() do
    update_interval_ms = Application.get_env(:vessel_tracker, :update_interval_ms)
    Logger.info("Check scheduled in #{update_interval_ms}ms")

    Process.send_after(
      self(),
      :check_vessel_info,
      update_interval_ms
    )
  end

  defp check_vessel_info() do
    Logger.debug("Checking vessel info...")

    previous_vessel_info = State.get()
    new_vessel_info = Scraper.getVesselInfo!()

    Logger.debug("Old")
    Logger.debug(inspect(previous_vessel_info))
    Logger.debug("New")
    Logger.debug(inspect(new_vessel_info))

    if Map.equal?(previous_vessel_info, new_vessel_info) do
      Logger.info("No new info is available")
    else
      Logger.info("New info is available, sending notifications")

      State.set(new_vessel_info)
      Notifier.send_text(new_vessel_info)
      Notifier.send_location(new_vessel_info)
    end
  end
end
