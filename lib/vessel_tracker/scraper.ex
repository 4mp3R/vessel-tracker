defmodule VesselTracker.Scraper do
  @moduledoc """
  This module is responsible for scraping the following information from vessel info pages:
  - Name of the vessel
  - Current route (form, to)
  - Last known location (latitute, longitude)
  """

  alias VesselTracker.VesselInfo

  def getVesselInfo! do
    %{body: body} = HTTPoison.get!(Application.get_env(:vessel_tracker, :finder_page))

    document = Floki.parse_document!(body)

    vessel_name = document |> Floki.find("h1") |> Floki.text()

    [to, from] =
      document
      |> Floki.find("._npNa")
      |> Enum.map(&Floki.text/1)

    lat = document |> Floki.find(".coordinate.lat") |> hd |> Floki.text()
    lon = document |> Floki.find(".coordinate.lon") |> hd |> Floki.text()

    VesselInfo.new!(vessel_name, from, to, lat, lon)
  end
end
