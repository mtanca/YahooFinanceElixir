defmodule YahooFinance do
  alias YahooFinance.{Historical, Snapshot, Quote}

  @doc """
  Returns `:ok` with the historical data.

  Example:
                            Symbol     Start          End
    YahooFinance.historical("AAPL", "2018-05-01", "2018-05-04")

    Output:
    {:ok,
      {"AAPL",
      ["Date,Open,High,Low,Close,Adj Close,Volume\n2018-05-01,166.410004,169.199997,165.270004,
      169.100006,168.450439,53569400\n2018-05-02,175.229996,177.750000,173.800003,176.570007,
      175.891754,66539400\n2018-05-03,175.880005,177.500000,174.440002,176.889999,176.210510,
      34068200\n2018-05-04,178.250000,184.250000,178.169998,183.830002,183.123856,56201300\n"]
      }
    }
  """
  def historical(symbol, start_period, end_period) do
    Historical.run(symbol, start_period, end_period)
  end

  @doc """
  Returns `:ok` with snapshot data. Provides data used mostly in fundamental analysis.

  Example:
                          Symbol                Modules
    YahooFinance.snapshot("AAPL", [:recommendationTrend, :indexTrend])

    Output:
    {:ok,
    {"AAPL",
      "{\"quoteSummary\":{\"result\":
        [{\"recommendationTrend\":{\"trend\":[{\"period\":\"0m\",\"strongBuy\":11,\"buy\":21,
        \"hold\":6,\"sell\":0,\"strongSell\":0},{\"period\":\"-1m\",\"strongBuy\":11,\"buy\":19,
        \"hold\":7,\"sell\":0,\"strongSell\":0},{\"period\":\"-2m\",\"strongBuy\":10,\"buy\":19,
        \"hold\":9,\"sell\":0,\"strongSell\":0},{\"period\":\"-3m\",\"strongBuy\":11,\"buy\":20,
        \"hold\":11,\"sell\":0,\"strongSell\":0}],\"maxAge\":86400},

        \"indexTrend\":{\"maxAge\":1,\"symbol\":\"SP5\",\"peRatio\":{\"raw\":18.0543,
        \"fmt\":\"18.05\"},\"pegRatio\":{\"raw\":1.69635,\"fmt\":\"1.70\"},
        \"estimates\":[{\"period\":\"0q\",\"growth\":{\"raw\":0.431,\"fmt\":\"0.43\"}},{\"period\":
        \"+1q\",\"growth\":{\"raw\":0.45,
        \"fmt\":\"0.45\"}},{\"period\":\"0y\",\"growth\":{\"raw\":0.214,\"fmt\":\"0.21\"}},
        {\"period\":\"+1y\",\"growth\":{\"raw\":0.099,\"fmt\":\"0.10\"}},{\"period\":\"+5y\",
        \"growth\":{\"raw\":0.111255,\"fmt\":\"0.11\"}},{\"period\":\"-5y\",\"growth\":{}}]}}],
        \"error\":null}}"
      }
    }
    NOTE: Module list can be found in README on https://github.com/mtanca/YahooFinanceElixir
  """
  def snapshot(symbol, module_args) do
    Snapshot.run(symbol, module_args)
  end

  def full_quote(symbol) do
    Quote.get_full_quote(symbol)
  end

  def simple_quote(symbol) do
    Quote.get_simple_quote(symbol)
  end

  @doc """
  Returns `:ok` with the custom quote data.

  Example:
                              Symbol                   Modules
    YahooFinance.custom_quote("FB", [:bid, :ask, :quoteType, :twoHundredDayAverage])

    Output:
    {:ok,
      {"FB",
      "{\"quoteResponse\":{\"result\":[{\"twoHundredDayAverage\":177.48935,
      \"quoteType\":\"EQUITY\",\"bid\":193.91,\"ask\":193.99}]}}"
      }
    }
    NOTE: Module list can be found in README on https://github.com/mtanca/YahooFinanceElixir
  """
  def custom_quote(symbol, module_args) do
    Quote.get_custom_quote(symbol, module_args)
  end
end
