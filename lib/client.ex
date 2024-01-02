defmodule Fedimintex.Client do
  @moduledoc """
  Handles HTTP requests for the `Fedimintex` client.
  """

  @type t :: %Fedimintex.Client{
          base_url: String.t(),
          password: String.t(),
          admin: atom(),
          mint: atom(),
          ln: atom(),
          wallet: atom()
        }

  @type http_response :: {:ok, map()} | {:error, String.t()}

  defstruct base_url: nil, password: nil, admin: nil, mint: nil, ln: nil, wallet: nil

  @doc """
  Creates a new `Fedimintex.Client` struct.
  """
  @spec new(String.t(), String.t()) :: t()
  def new(base_url \\ System.get_env("BASE_URL"), password \\ System.get_env("PASSWORD")) do
    %Fedimintex.Client{
      base_url: base_url <> "/fedimint/v2",
      password: password,
      admin: Fedimintex.Admin,
      mint: Fedimintex.Mint,
      ln: Fedimintex.Ln,
      wallet: Fedimintex.Wallet
    }
  end

  @doc """
  Makes a GET request to the `baseURL` at the given `endpoint`.
  Receives a JSON response.
  """
  @spec get(t(), String.t()) :: http_response()
  def get(%Fedimintex.Client{} = client, endpoint) do
    headers = [{"Authorization", "Bearer #{client.password}"}]

    Req.get!(client.base_url <> endpoint, headers: headers)
    |> handle_response()
  end

  @doc """
  Makes a POST request to the `baseURL` at the given `endpoint`
  Receives a JSON response.
  """
  @spec post(t(), String.t(), map()) :: http_response()
  def post(%Fedimintex.Client{} = client, endpoint, body) do
    headers = [
      {"Authorization", "Bearer #{client.password}"},
      {"Content-Type", "application/json"}
    ]

    Req.post!(client.base_url <> endpoint, json: body, headers: headers)
    |> handle_response()
  end

  @spec handle_response(Req.Response.t()) :: http_response()
  defp handle_response(response) do
    case response.status do
      200 ->
        body = Jason.decode!(response.body)
        {:ok, body}
      status_code -> {:error, "Request failed with status #{status_code}"}
    end
  rescue
    e in Jason.DecodeError -> {:error, "Failed to decode response body: #{e.message}"}
  end
end
