defmodule YahooFinance.HistoricalTest do
  use ExUnit.Case
  doctest YahooFinance

  test "history- returns :error when symbol arg not given as string" do
    results = YahooFinance.historical(1, "2018-05-28", "2018-05-29")
    assert results == {:error, "Symbol argument must be given as string"}
  end

  test "history- returns :error when start date not given as string" do
    results = YahooFinance.historical("AAPL", 2018-05-28, "2018-05-29")
    assert results == {:error, "Starting date must be given as string"}
  end

  test "history- returns :error when end date not given as string" do
    results = YahooFinance.historical("AAPL", "2018-05-28", 2018-05-29)
    assert results == {:error, "Ending date must be given as string"}
  end

  test "history- returns :error for invalid symbol" do
    results = YahooFinance.historical("AXAPL", "2018-05-28", "2018-05-29")
    assert results == {:error, "Invalid symbol given as argument"}
  end

  test "history- returns :error if start date > end date" do
    results = YahooFinance.historical("AAPL", "2018-05-30", "2018-05-01")
    assert results == {:error, "Invalid input - start date cannot be after end date. startDate = 1527674400, endDate = 1525168800"}
  end

  test "history- throws :error if symbol is given as empty string" do
    results = YahooFinance.historical("", "2018-05-30", "2018-05-01")
    assert results == {:error, "Cannot provide empty string as argument"}
  end

  test "history- throws :error if both dates are given in invalid format" do
    results = YahooFinance.historical "AAPL", "05-15-2018", "06-01-2018"
    assert results == {:error, "A date was given as an invalid format. Format as: YYYY-MM-DD"}
  end

  test "history- throws :error if start date is given in invalid format" do
    results = YahooFinance.historical "AAPL", "05-15-2018", "2018-06-01"
    assert results == {:error, "A date was given as an invalid format. Format as: YYYY-MM-DD"}
  end

  test "history- throws :error if end date is given in invalid format" do
    results = YahooFinance.historical "AAPL", "2018-05-20", "06-01-2018"
    assert results == {:error, "A date was given as an invalid format. Format as: YYYY-MM-DD"}
  end

  test "history- returns correct data per parameters" do
    results = YahooFinance.historical("AAPL", "2018-05-29", "2018-05-29")
    assert results =
      {:ok,
        {"AAPL", "Date,Open,High,Low,Close,Adj Close,Volume\n2018-05-29,187.600006,188.750000,186.869995,187.899994,187.899994,22369000\n"}
      }
  end
end
