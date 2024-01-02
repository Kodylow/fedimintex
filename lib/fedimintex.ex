defmodule Fedimintex do
  @moduledoc """
  Documentation for `Fedimintex`.
  """

  @type t :: %Fedimintex{
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
  Creates a new `Fedimintex` client.
  """
  @spec new(String.t(), String.t()) :: t()
  def new(base_url \\ System.get_env("BASE_URL"), password \\ System.get_env("PASSWORD")) do
    %Fedimintex{
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
  def get(%Fedimintex{} = client, endpoint) do
    headers = [{"Authorization", "Bearer #{client.password}"}]
    IO.inspect("headers: #{headers}", label: "Headers")
    HTTPoison.get("#{client.base_url}#{endpoint}", headers)
    |> handle_response(200)
  end

  @doc """
  Makes a POST request to the `baseURL` at the given `endpoint`
  Receives a JSON response.
  """
  @spec post(t(), String.t(), map()) :: http_response()
  def post(%Fedimintex{} = client, endpoint, body) do
    headers = [
      {"Authorization", "Bearer #{client.password}"},
      {"Content-Type", "application/json"}
    ]
    IO.inspect("headers: #{headers}", label: "Headers")

    HTTPoison.post("#{client.base_url}#{endpoint}", Jason.encode!(body), headers)
    |> handle_response(200)
  end

  @spec handle_response({:ok, %HTTPoison.Response{}}, integer()) :: http_response()
  defp handle_response(
         {:ok, %HTTPoison.Response{status_code: expected_status_code, body: body}},
         expected_status_code
       ) do
    IO.inspect(body, label: "Response body")
    {:ok, Jason.decode!(body)}
  end

  @spec handle_response({:ok, %HTTPoison.Response{}}, integer()) :: http_response()
  defp handle_response(
         {:ok, %HTTPoison.Response{status_code: status_code}},
         _expected_status_code
       ) do
    {:error, "Request failed with status #{status_code}"}
  end

  @spec handle_response({:error, %HTTPoison.Error{}}, integer()) :: http_response()
  defp handle_response({:error, %HTTPoison.Error{reason: reason}}, _expected_status_code) do
    {:error, reason}
  end
end
