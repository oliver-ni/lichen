defmodule Lichen.API.Endpoint do
  use Plug.Router

  plug Plug.Logger
  plug :match
  plug Plug.Parsers, parsers: [:json], json_decoder: Jason
  plug :dispatch

  get "/" do
    send_resp(conn, 200, "Welcome!")
  end

  post "/" do
    {status_code, status, value} =
      case conn.body_params do
        %{"files" => files, "lang" => lang} ->
          base = Map.get(conn.body_params, "base")
          lang = Lichen.API.LanguageRegistry.get(lang)
          {200, "success", Lichen.compare(files, base, lang)}

        _ ->
          {400, "error", ~s'You must specify the "files" and "lang" keys.'}
      end

    send_json(conn, status_code, %{status: status, value: value})
  end

  match _ do
    send_resp(conn, 404, "Not Found")
  end

  defp send_json(conn, status_code, json) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status_code, Jason.encode!(json))
    |> halt()
  end
end
