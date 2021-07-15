defmodule VesselTracker.State do
  @moduledoc """
  This modules provides in-memory runtime storage for the last known vessel info.
  As other parts of the app such as web scraping and messaging are likely to fail
  from time to time becuase of network conditions, state is kept in a separate process.
  """

  alias VesselTracker.VesselInfo

  use GenServer

  require Logger

  ### Client API

  def start_link(default_state) do
    GenServer.start_link(__MODULE__, default_state, name: __MODULE__)
  end

  def get do
    GenServer.call(__MODULE__, :get)
  end

  def set(%VesselInfo{} = vessel_info) do
    GenServer.cast(__MODULE__, {:set, vessel_info})
  end

  ### Server API

  def init(default_state) do
    :dets.open_file(:vessel_info_storage, type: :set)

    initial_state =
      case :dets.lookup(:vessel_info_storage, :vessel_info) do
        [vessel_info: vessel_info] -> vessel_info
        _ -> default_state
      end

    Logger.debug("Initial state")
    Logger.debug(inspect(initial_state))

    {:ok, initial_state}
  end

  def handle_call(:get, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:set, %VesselInfo{}} = {:set, new_state}, _state) do
    :dets.insert(:vessel_info_storage, {:vessel_info, new_state})

    {:noreply, new_state}
  end

  def terminate(reason, state) do
    :dets.close(:vessel_info_storage)

    Logger.critical("State process terminated")
    Logger.critical(inspect(reason))
    Logger.critical(inspect(state))
  end
end
