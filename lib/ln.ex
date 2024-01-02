# ln.ex
defmodule Fedimintex.Ln do
  import Fedimintex, only: [post: 3, get: 2]

  @type ln_invoice_request :: %{
          amount_msat: non_neg_integer(),
          description: String.t(),
          expiry_time: non_neg_integer() | nil
        }

  @type ln_invoice_response :: %{
          operation_id: String.t(),
          invoice: String.t()
        }

  @spec create_invoice(Fedimintex.t(), ln_invoice_request()) ::
          {:ok, ln_invoice_response()} | {:error, String.t()}
  def create_invoice(client, request) do
    post(client, "/ln/invoice", request)
  end

  @type await_invoice_request :: %{
          operation_id: String.t()
        }

  @spec await_invoice(Fedimintex.t(), await_invoice_request()) ::
          {:ok, ln_invoice_response()} | {:error, String.t()}
  def await_invoice(client, request) do
    post(client, "/ln/await-invoice", request)
  end

  @type ln_pay_request :: %{
          payment_info: String.t(),
          amount_msat: non_neg_integer() | nil,
          finish_in_background: boolean(),
          lnurl_comment: String.t() | nil
        }

  @type ln_pay_response :: %{
          operation_id: String.t(),
          payment_type: String.t(),
          contract_id: String.t(),
          fee: non_neg_integer()
        }

  @spec pay(Fedimintex.t(), ln_pay_request()) :: {:ok, ln_pay_response()} | {:error, String.t()}
  def pay(client, request) do
    post(client, "/ln/pay", request)
  end

  @type await_ln_pay_request :: %{
          operation_id: String.t()
        }

  @spec await_pay(Fedimintex.t(), await_ln_pay_request()) ::
          {:ok, ln_pay_response()} | {:error, String.t()}
  def await_pay(client, request) do
    post(client, "/ln/await-pay", request)
  end

  @type gateway :: %{
          node_pub_key: String.t(),
          active: boolean()
        }

  @spec list_gateways(Fedimintex.t()) :: {:ok, [gateway()]} | {:error, String.t()}
  def list_gateways(client) do
    get(client, "/ln/list-gateways")
  end

  @type switch_gateway_request :: %{
          gateway_id: String.t()
        }

  @spec switch_gateway(Fedimintex.t(), switch_gateway_request()) ::
          {:ok, String.t()} | {:error, String.t()}
  def switch_gateway(client, request) do
    post(client, "/ln/switch-gateway", request)
  end
end
