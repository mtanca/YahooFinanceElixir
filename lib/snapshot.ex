defmodule YahooFinance.Snapshot do
  @moduledoc """
    Contains the functions needed to pull snapshot stock data.
  """
  import Utils

  def run("", _), do:
    {:error, "Cannot provide empty string as argument"}

  def run(symbol, _module_args) when not is_string_like(symbol), do:
    {:error, "Symbol argument must be given as string"}

  def run(_symbol, []), do:
    {:error, "Module list cannot be empty"}

  def run(_symbol, module_args) when not is_list(module_args), do:
    {:error, "Modules must be given as a list"}

  def run(symbol, module_args) do
    case valid_modules?(module_args) do
      false ->
        {:error, "One or more of modules entered is invalid"}
      true ->
        module_args
        |> Enum.map(fn(arg) -> Atom.to_string(arg) end)
        |> build_module_query
        |> request_snapshot(symbol)
        |> handle_response(symbol)
    end
  end

  # PRIVATE FUNCTIONS
  defp valid_modules?(args) do
    modules = get_modules()
    !Enum.any?(args, &(Enum.member?(modules, &1) == false))
  end

  defp build_module_query(args, query_builder \\ "")

  defp build_module_query([arg], query_builder), do: query_builder <> arg

  defp build_module_query(args, query_builder) do
    [arg | tail] = args
    build_module_query(tail, query_builder <> "#{arg}%2C")
  end

  defp request_snapshot(args, symbol) do
    HTTPoison.get! "https://query1.finance.yahoo.com/v10/finance/quoteSummary/#{symbol}?modules=#{args}"
  end

  defp handle_response(response, symbol) do
    case response.status_code do
      200 -> {:ok, {symbol, response.body}}
      _ -> handle_error(Poison.decode(response.body))
    end
  end

  defp handle_error({_, %{"quoteSummary" => info}}), do: {:error, info["error"]["description"]}

  defp handle_error(_), do: {:error, "Encountered an error unhandled by this API. If reproducible, report as bug"}

  defp get_modules do
    [
      :assetProfile,
      :incomeStatementHistory,
      :incomeStatementHistoryQuarterly,
      :balanceSheetHistory,
      :balanceSheetHistoryQuarterly,
      :cashflowStatementHistory,
      :cashflowStatementHistoryQuarterly,
      :defaultKeyStatistics,
      :financialData,
      :calendarEvents,
      :secFilings,
      :recommendationTrend,
      :upgradeDowngradeHistory,
      :institutionOwnership,
      :fundOwnership,
      :majorDirectHolders,
      :majorHoldersBreakdown,
      :insiderTransactions,
      :insiderHolders,
      :netSharePurchaseActivity,
      :earnings,
      :earningsHistory,
      :earningsTrend,
      :industryTrend,
      :indexTrend,
      :sectorTrend
    ]
  end
end
