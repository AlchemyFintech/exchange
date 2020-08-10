defmodule Exchange do
  @moduledoc """
  Documentation for `Exchange`.
  """

  @doc """
  Place a limit order on the order book

  ## Examples

  iex(2)> Exchange.place_order(%{
  ...> type: :limit, price: 1,
  ...> order_id: "a", trader_id: "b",
  ...> side: "buy", size: 10 }, :AUXLND)

  {:error, "Invalid argument; Not a valid UUID: a"}

  iex(3)> Exchange.place_order(%{
  ...> type: :limit, price: 1,
  ...> order_id: UUID.uuid1, trader_id: UUID.uuid1,
  ...> side: "buy", size: 10 }, :AUXLND)

  {:error, "Order Side accepted values are: - :buy or :sell"}

  iex(4)> Exchange.place_order(%{
  ...> type: :limit, price: 1,
  ...> order_id: UUID.uuid1, trader_id: UUID.uuid1,
  ...> side: :buy, size: 10 }, :AUXLND)

  :ok
  """

  def place_order(%{type: :limit} = order_params, ticker) do
    case Exchange.Validations.cast_order(order_params) do
      {:ok, limit_order} ->
        Exchange.MatchingEngine.place_limit_order(ticker, limit_order)

      {:error, errors} ->
        {:error, errors}
    end
  end

  @doc """
  Places a market order on the Exchange

  iex(4)> Exchange.place_order(%{
  ...> type: :market,
  ...> order_id: UUID.uuid1, trader_id: UUID.uuid1,
  ...> side: :buy, size: 10 }, :AUXLND)

  :ok
  """
  def place_order(%{type: :market} = order_params, ticker) do
    case Exchange.Validations.cast_order(order_params) do
      {:ok, market_order} ->
        Exchange.MatchingEngine.place_market_order(ticker, market_order)

      {:error, errors} ->
        {:error, errors}
    end
  end

  @doc """
  Places a marketable limit order on the Exchange
  """
  def place_order(%{type: :marketable_limit} = order_params, ticker) do
    case Exchange.Validations.cast_order(order_params) do
      {:ok, marketable_limit_order} ->
        Exchange.MatchingEngine.place_marketable_limit_order(ticker, marketable_limit_order)

      {:error, errors} ->
        {:error, errors}
    end
  end

  @doc """
  Cancels an order on the Exchange

  """
  def cancel_order(order_id, ticker) do
    Exchange.MatchingEngine.cancel_order(ticker, order_id)
  end

  # Level 1 Market Data

  def spread(ticker) do
    Exchange.MatchingEngine.spread(ticker)
  end

  def highest_bid_price(ticker) do
    Exchange.MatchingEngine.bid_max(ticker)
  end

  def highest_bid_volume(ticker) do
    Exchange.MatchingEngine.bid_volume(ticker)
  end

  def lowest_ask_price(ticker) do
    Exchange.MatchingEngine.ask_min(ticker)
  end

  def highest_ask_volume(ticker) do
    Exchange.MatchingEngine.ask_volume(ticker)
  end

  def open_orders(ticker) do
    Exchange.MatchingEngine.open_orders(ticker)
  end

  def open_orders_by_trader(ticker, trader_id) do
    Exchange.MatchingEngine.open_orders_by_trader(ticker, trader_id)
  end

  def last_price do
  end

  def last_size do
  end

  @spec completed_trades_by_id(atom, String.t() | atom()) :: [Exchange.Trade]

  def completed_trades_by_id(ticker, trader_id) when is_atom(trader_id) do
    completed_trades_by_id(ticker, Atom.to_string(trader_id))
  end

  def completed_trades_by_id(ticker, trader_id) do
    Exchange.Utils.fetch_completed_trades(ticker, trader_id)
  end

  def total_buy_orders(ticker) do
    Exchange.MatchingEngine.total_bid_orders(ticker)
  end

  def total_sell_orders(ticker) do
    Exchange.MatchingEngine.total_ask_orders(ticker)
  end
end