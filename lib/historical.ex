defmodule YahooFinance.Historical do
  @moduledoc """
    Contains the functions needed to pull historical stock data.
  """
  import Utils

  def run("", _, _), do:
    {:error, "Cannot provide empty string as argument"}

  def run(symbol, _, _) when not is_string_like(symbol), do:
    {:error, "Symbol argument must be given as string"}

  def run(_symbol, start_period, _) when not is_string_like(start_period), do:
    {:error, "Starting date must be given as string"}

  def run(_, _, end_period) when not is_string_like(end_period), do:
    {:error, "Ending date must be given as string"}

  def run(symbol, start_period, end_period) do
    request = request_with_cookie_and_crumb(symbol)

    case request.status_code do
      200 -> handle_success(request, symbol, start_period, end_period)
      _ -> handle_error(request.status_code)
    end
  end

  # PRIVATE FUNCTIONS

  # This request is required in order to extract the cookie & crumb needed
  # for the historical data request. See: download_url/4.
  defp request_with_cookie_and_crumb(symbol) do
    HTTPoison.get!("https://finance.yahoo.com/quote/#{symbol}/history")
  end

  defp handle_success(results, symbol, start_period, end_period) do
    cookie = results.headers |> extract_cookie
    crumb  = results.body |> extract_crumb |> format_crumb
    [start_date, end_date] = convert_dates(start_period, end_period)

    if has_valid_dates?(start_date, end_date) do
      download(symbol, start_date, end_date, cookie, crumb)
    else
      {:error, "A date was given as an invalid format. Format as: YYYY-MM-DD"}
    end
  end

  defp extract_cookie(response_headers) do
    [{_, cookie}] = Enum.filter(response_headers, fn
       {"Set-Cookie", _} -> true
       _ -> false
    end)

    cookie
  end

  # The crumb is the token tied to the cookie for the download request.
  # YahooFinance requires the crumb as part of request url.
  defp extract_crumb(reponse_body) do
    crumb = Regex.scan ~r/"crumb":"(.+?)"/, reponse_body

    crumb
    |> List.last
    |> Enum.at(1)
  end

  # We have to replace "\u002F" with the "/" in the crumb or else the api call will fail...
  # It's possible "\u002F" is not in the crumb, so we only replace if need be.
  defp format_crumb(crumb) do
    cond do
      String.contains?(crumb, "002F") -> String.replace crumb, "\\u002F", "/"
      true -> crumb
    end
  end

  defp convert_dates(start_period, end_period) do
    Enum.map([start_period, end_period], &(to_unix(&1)))
  end

  defp to_unix(date) do
    case DateTime.from_iso8601("#{date}T10:00:00Z") do
      {:error, _} -> {:error, "Date was given as an invalid format"}
      {:ok, datetime, _} -> DateTime.to_unix(datetime)
    end
  end

  defp has_valid_dates?(start_date, end_date) do
    case [start_date, end_date] do
      [{:error, _}, _] -> false
      [_, {:error,_}] -> false
      _ -> true
    end
  end

  defp download(symbol, start_date, end_date, cookie, crumb) do
    url = download_url(symbol, start_date, end_date, crumb)
    results = request_download(url, cookie)

    handle_download(results.status_code, results.body, symbol)
  end

  defp download_url(symbol, start_date, end_date, crumb) do
    "https://query1.finance.yahoo.com/v7/finance/download/#{symbol}?period1=#{start_date}&period2=#{end_date}&interval=1d&events=history&crumb=#{crumb}"
  end

  defp request_download(url, cookie) do
    HTTPoison.get!(url, %{}, hackney: [cookie: [cookie]])
  end

  defp handle_download(200, data, symbol) do
    {:ok, {symbol, [data]}}
  end

  defp handle_download(_, data, _) do
    {_, response} = Poison.decode(data)
    handle_error(response)
  end

  defp handle_error(301), do:
    {:error, "Invalid symbol given as argument"}

  defp handle_error(401), do:
    {:error, "Issue getting cookie - Invalid Cookie"}

  defp handle_error(400), do:
    {:error, "Issue getting API - Invalid Request"}

  defp handle_error(%{"finance" => info}), do:
    {:error, info["error"]["description"]}

  defp handle_error(%{"chart" => info}), do:
    {:error, info["error"]["description"]}

  defp handle_error(_), do:
    {:error, "Encountered an error unhandled by library. If reproducible, report as bug"}
end
