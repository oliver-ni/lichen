# ---- Build Stage ----
FROM elixir:1.11.2-alpine as builder
RUN mkdir /app
WORKDIR /app
COPY . .
ENV MIX_ENV=prod
RUN apk add --no-cache git \
    && mix local.rebar --force \
    && mix local.hex --force \
    && mix deps.get \
    && mix release

# ---- Application Stage ----
FROM alpine:3
RUN mkdir /app
WORKDIR /app
COPY --from=builder /app/_build /app
RUN apk add --no-cache bash
CMD ["/app/prod/rel/lichen_server/bin/lichen_server", "start"]