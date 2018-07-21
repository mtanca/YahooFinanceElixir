defmodule YahooFinance.Quote do
  @moduledoc """
    Contains the functions needed to pull quote data.
  """
  import Utils
  
  def get_full_quote(""), do:
    {:error, "Cannot provide empty string as argument"}

  def get_full_quote(symbol) when not is_string_like(symbol), do:
    {:error, "Symbol argument must be given as string"}

  def get_full_quote(symbol) do
    request = request_quote(symbol)

    case request.status_code do
      200 -> {:ok, {symbol, request.body}}
      _ -> "Error"
    end
  end

  def get_simple_quote(""), do:
    {:error, "Cannot provide empty string as argument"}

  def get_simple_quote(symbol) when not is_string_like(symbol), do:
    {:error, "Symbol argument must be given as string"}

  def get_simple_quote(symbol) do
    request = request_quote(symbol)

    case request.status_code do
      200 -> handle_quote_success(symbol, request.body)
      _ -> "Error"
    end
  end

  def get_custom_quote("", _), do:
    {:error, "Cannot provide empty string as argument"}

  def get_custom_quote(symbol, _args) when not is_string_like(symbol), do:
    {:error, "Symbol argument must be given as string"}

  def get_custom_quote(_symbol, args) when not is_list(args), do:
    {:error, "Arguments must be given as list"}

  def get_custom_quote(_symbol, []), do:
    {:error, "List arguments must not be empty"}

  def get_custom_quote(symbol, args) do
    case valid_modules?(args) do
      false ->
        {:error, "One or more of modules entered is invalid"}
      true ->
        symbol
        |> request_quote
        |> handle_custom_quote(symbol, args)
    end
  end

  defp request_quote(symbol) do
    HTTPoison.get! "https://query1.finance.yahoo.com/v7/finance/quote?symbols=#{symbol}"
  end

  defp handle_custom_quote(results, symbol, args) do
    case results.status_code do
      200 -> handle_quote_success(symbol, results.body, args)
      _ -> {:error, "Error with query..."}
    end
  end

  defp handle_quote_success(symbol, data, args \\ get_simple_quote_args())

  defp handle_quote_success(symbol, data, args) do
    {_, results} = Poison.decode(data)
    [quote_response] = results["quoteResponse"]["result"]

    quote_data = args
    |> Enum.map(fn(arg) -> Atom.to_string(arg) end)
    |> Enum.reduce(%{}, fn(arg, acc) -> Map.merge(acc, %{arg => quote_response[arg]}) end)
    |> encode

     {:ok, {symbol, quote_data}}
  end

  defp encode(data) do
    Poison.encode!(
      %{
        "quoteResponse" => %{
          "result" => [data]
        }
      }
    )
  end

  defp valid_modules?(args) do
    modules = get_modules()
    !Enum.any?(args, &(Enum.member?(modules, &1) == false))
  end

  defp get_simple_quote_args do
    [
      :regularMarketPrice,
      :regularMarketChange,
      :regularMarketOpen,
      :regularMarketDayHigh,
      :regularMarketDayLow,
      :regularMarketPreviousClose,
      :regularMarketVolume,
      :bid,
      :ask
    ]
  end

  defp get_modules do
    [
      :ask,
      :askSize,
      :averageDailyVolume10Day,
      :averageDailyVolume3Month,
      :bid,
      :bidSize,
      :bookValue,
      :currency,
      :earningsTimestamp,
      :earningsTimestampEnd,
      :earningsTimestampStart,
      :epsForward,
      :epsTrailingTwelveMonths,
      :esgPopulated,
      :exchange,
      :exchangeDataDelayedBy,
      :exchangeTimezoneName,
      :exchangeTimezoneShortName,
      :fiftyDayAverage,
      :fiftyDayAverageChange,
      :fiftyDayAverageChangePercent,
      :fiftyTwoWeekHigh,
      :fiftyTwoWeekHighChange,
      :fiftyTwoWeekHighChangePercent,
      :fiftyTwoWeekLow,
      :fiftyTwoWeekLowChange,
      :fiftyTwoWeekLowChangePercent,
      :fiftyTwoWeekRange,
      :financialCurrency,
      :forwardPE,
      :fullExchangeName,
      :gmtOffSetMilliseconds,
      :language,
      :longName,
      :market,
      :marketCap,
      :marketState,
      :messageBoardId,
      :postMarketChange,
      :postMarketChangePercent,
      :postMarketPrice,
      :postMarketTime,
      :priceHint,
      :priceToBook,
      :quoteSourceName,
      :quoteType,
      :regularMarketChange,
      :regularMarketChangePercent,
      :regularMarketDayHigh,
      :regularMarketDayLow,
      :regularMarketDayRange,
      :regularMarketOpen,
      :regularMarketPreviousClose,
      :regularMarketPrice,
      :regularMarketTime,
      :regularMarketVolume,
      :sharesOutstanding,
      :shortName,
      :sourceInterval,
      :symbol,
      :tradeable,
      :trailingPE,
      :twoHundredDayAverage,
      :twoHundredDayAverageChange,
      :twoHundredDayAverageChangePercent
    ]
  end
end
