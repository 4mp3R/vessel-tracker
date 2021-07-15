# VesselTracker

Track position of vessels of your interest and receive updates via Telegram.

## Installation

- Get [Elixir](https://elixir-lang.org/install.html)
- Install the dependencies with `mix do deps.get, deps.compile`

## Configuration

- Create a `config/config.exs` file from the `config/config.exs.template` template and fill in the missing values

## Running the app

- Compile the app with `mix compile`
- Make a new release with `mix release --overwrite`
- Start the app with `_build/dev/rel/vessel_tracker/bin/vessel_tracker start`
- Stop the app with `_build/dev/rel/vessel_tracker/bin/vessel_tracker stop`

## Building a Docker image

- `docker build . -t vessel-tracker`
- Run it with `docker run vessel-tracker`
