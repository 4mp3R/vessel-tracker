# Build the release
# -----------------

FROM elixir:1.12-alpine as build

ENV MIX_ENV=prod

# Git

RUN apk add git

# HEX and Rebar

RUN mix local.hex --force && mix local.rebar --force

# Install and compile dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix do deps.get, deps.compile

# Compile and build the app
COPY . .
RUN mix do compile, release


# Run the app
# -----------

FROM elixir:1.12-alpine

ENV MIX_ENV=prod

COPY --from=build _build/${MIX_ENV}/rel/vessel_tracker .

CMD ["bin/vessel_tracker", "start"]
