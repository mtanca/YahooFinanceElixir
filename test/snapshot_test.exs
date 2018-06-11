defmodule YahooFinance.SnapshotTest do
  use ExUnit.Case
  doctest YahooFinance

  test "snapshot- returns a successful call" do
    results =  YahooFinance.snapshot "AAPL", [:assetProfile, :incomeStatementHistory]
    assert elem(results, 0) == :ok
  end

  test "snapshot- thorws error if invalid module is supplied" do
    results =  YahooFinance.snapshot "AAPL", [:assetProfile, :incomeStmentH]
    assert results == {:error, "One or more of modules entered is invalid"}
  end

  test "snapshot- throws error if module args are not provided as list" do
    results =  YahooFinance.snapshot "AAPL", :assetProfile
    assert results == {:error, "Modules must be given as a list"}
  end

  test "snapshot- throws error module list is empty" do
    results =  YahooFinance.snapshot "AAPL", []
    assert results == {:error, "Module list cannot be empty"}
  end

  test "snapshot- throws error invalid ticker is supplied" do
    results =  YahooFinance.snapshot "1", [:assetProfile]
    assert results == {:error, "Quote not found for ticker symbol: 1"}
  end

  test "snapshot- throws error empty ticker is supplied" do
    results =  YahooFinance.snapshot "", [:assetProfile]
    assert results == {:error, "Cannot provide empty string as argument"}
  end
end
