defmodule VesselTracker do
  @moduledoc """
  Vessel Tracker app consists of 2 processes:
  - Checker: checks for the new vessel data and sends notifications, error-prone due to network
  - State: holds the last known vessel data, stable
  """

  alias VesselTracker.{Checker, State}

  use Application

  require Logger

  def start(_type, _args) do
    Logger.info("Starting VesselTracker application")

    children = [
      %{
        id: Checker,
        start: {Checker, :start_link, []}
      },
      %{
        id: State,
        start: {State, :start_link, [%{}]}
      }
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end

  def stop do
    Logger.info("Stopping VesselTracker application")

    :ok
  end
end
