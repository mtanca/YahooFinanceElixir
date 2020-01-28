defmodule YahooFinanceTest do
  use ExUnit.Case
  doctest YahooFinance

  test "history- returns successful call with :ok" do
    results = YahooFinance.historical("AAPL", "2018-05-28", "2018-05-29")
    assert elem(results, 0) == :ok
  end

  test "snapshot- returns a successful call  with :ok" do
    results = YahooFinance.snapshot("AAPL", [:assetProfile, :incomeStatementHistory])
    assert elem(results, 0) == :ok
  end

  test "full_quote- returns successful call with :ok" do
    results = YahooFinance.full_quote("AAPL")
    assert elem(results, 0) == :ok
  end

  test "simple_quote- returns successful call with :ok" do
    results = YahooFinance.simple_quote("AAPL")
    assert elem(results, 0) == :ok
  end

  test "custom_quote- returns successful call with :ok" do
    results = YahooFinance.custom_quote("AAPL", [:bid])
    assert elem(results, 0) == :ok
  end

  test "functions can recieve string-like args as charlist" do
    {historical, _} = YahooFinance.historical('AAPL', '2018-05-28', '2018-05-29')
    {snapshot, _} = YahooFinance.snapshot('AAPL', [:incomeStatementHistory])
    {f_quote, _} = YahooFinance.full_quote('AAPL')
    {s_quote, _} = YahooFinance.simple_quote('AAPL')
    {c_quote, _} = YahooFinance.custom_quote('AAPL', [:bid])

    assert Enum.member?([historical, snapshot, f_quote, s_quote, c_quote], :error) == false
  end
end
