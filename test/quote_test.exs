defmodule YahooFinance.QuoteTest do
  use ExUnit.Case
  doctest YahooFinance

  test "full_quote- throws error if symbol given as atom" do
    results = YahooFinance.full_quote(:AAPL)
    assert results == {:error, "Symbol argument must be given as string"}
  end

  test "simple_quote- throws error if symbol not given as string" do
    results = YahooFinance.simple_quote(AAPL)
    assert results == {:error, "Symbol argument must be given as string"}
  end

  test "custom_quote- throws error if symbol not given as string" do
    results = YahooFinance.custom_quote(AAPL, [:bid])
    assert results == {:error, "Symbol argument must be given as string"}
  end

  test "custom_quote- throws error if module list is empty" do
    results = YahooFinance.custom_quote("AAPL", [])
    assert results == {:error, "List arguments must not be empty"}
  end
end
