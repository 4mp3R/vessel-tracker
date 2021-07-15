defmodule VesselTracker.VesselInfo do
  @moduledoc """
  This module defines a struct holding vessel info and a standard way to generate it.
  It provides some basic validation - all the keys need to be defined and have non-empty
  string values.
  """

  alias __MODULE__

  @enforce_keys [:vessel_name, :from, :to, :lat, :lon]
  defstruct [:vessel_name, :from, :to, :lat, :lon]

  def new!(vessel_name, from, to, lat, lon) do
    arguments = [vessel_name, from, to, lat, lon]

    case Enum.all?(arguments, fn item -> String.length(item) > 0 end) do
      true ->
        %VesselInfo{vessel_name: vessel_name, to: to, from: from, lat: lat, lon: lon}

      _ ->
        raise "Some or all of the VesselInfo arguments are empty: " <> Enum.join(arguments, ", ")
    end
  end
end
