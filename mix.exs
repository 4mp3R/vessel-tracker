defmodule VesselTracker.MixProject do
  use Mix.Project

  def project do
    [
      app: :vessel_tracker,
      mod: {VesselTracker, []},
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {VesselTracker, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:telegram, git: "https://github.com/visciang/telegram.git", tag: "0.7.1"},
      {:httpoison, "1.8.0"},
      {:floki, "0.31.0"}
    ]
  end
end
