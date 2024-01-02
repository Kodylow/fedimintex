# wallet.ex
defmodule Fedimintex.Wallet do
  import Fedimintex, only: [post: 3]

  @type deposit_address_request :: %{timeout: integer()}
  @type deposit_address_response :: %{operation_id: String.t(), address: String.t()}

  @spec create_deposit_address(Fedimintex.t(), deposit_address_request()) ::
          {:ok, deposit_address_response()} | {:error, String.t()}
  def create_deposit_address(client, request) do
    post(client, "/wallet/deposit-address", request)
  end

  @type await_deposit_request :: %{operation_id: String.t()}
  @type await_deposit_response :: %{status: String.t()}

  @spec await_deposit(Fedimintex.t(), await_deposit_request()) ::
          {:ok, await_deposit_response()} | {:error, String.t()}
  def await_deposit(client, request) do
    post(client, "/wallet/await-deposit", request)
  end

  @type withdraw_request :: %{address: String.t(), amount_msat: String.t()}
  @type withdraw_response :: %{txid: String.t(), fees_sat: integer()}

  @spec withdraw(Fedimintex.t(), withdraw_request()) ::
          {:ok, withdraw_response()} | {:error, String.t()}
  def withdraw(client, request) do
    post(client, "/wallet/withdraw", request)
  end
end
