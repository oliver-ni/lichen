defmodule Lichen.API.Endpoint do
  use Plug.Router

  plug Plug.Logger
  plug :match
  plug Plug.Parsers, parsers: [:json], json_decoder: Jason
  plug :dispatch

  get "/" do
    send_resp(conn, 200, "Welcome to the Lichen API")
  end

  match _ do
    send_resp(conn, 404, "Not Found")
  end
end
