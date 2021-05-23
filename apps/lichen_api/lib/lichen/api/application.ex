defmodule Lichen.API.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Lichen.API.LanguageRegistry,
      {
        Plug.Cowboy,
        scheme: :http, plug: Lichen.API.Endpoint, options: [port: 4000]
      }
    ]

    opts = [strategy: :one_for_one, name: Lichen.API.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
