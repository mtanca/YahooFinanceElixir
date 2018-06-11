defmodule YahooFinance do
  alias YahooFinance.{Historical, Snapshot, Quote}

  def historical(symbol, start_period, end_period) do
    Historical.run(symbol, start_period, end_period)
  end

  def snapshot(symbol, module_args) do
    Snapshot.run(symbol, module_args)
  end

  def full_quote(symbol) do
    Quote.get_full_quote(symbol)
  end

  def simple_quote(symbol) do
    Quote.get_simple_quote(symbol)
  end

  def custom_quote(symbol, module_args) do
    Quote.get_custom_quote(symbol, module_args)
  end
end
