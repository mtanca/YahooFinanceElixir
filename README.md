# Yahoo-Finance Elixir

A simple elixir wrapper around Yahoo-Finance. Get historical and real-time information easily, efficiently, and free =).

## Installation

The package can be installed by adding `yahoo_finance_elixir`
to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:yahoo_finance_elixir, "~> 0.1.3"}
  ]
end
```

## Historical

Yahoo-Finance has terminated its service on the well used EOD data download without warning some time ago. The historical/3 function provides a work around for getting historical/EOD data.

### Historical Example

```elixir
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
```

## Snapshot

Provides data used in fundamental analysis.

Module arguments:

```elixir
* :assetProfile
* :incomeStatementHistory
* :incomeStatementHistoryQuarterly
* :balanceSheetHistory
* :balanceSheetHistoryQuarterly
* :cashflowStatementHistory
* :cashflowStatementHistoryQuarterly
* :defaultKeyStatistics
* :financialData
* :calendarEvents
* :secFilings
* :recommendationTrend
* :upgradeDowngradeHistory
* :institutionOwnership
* :fundOwnership
* :majorDirectHolders
* :majorHoldersBreakdown
* :insiderTransactions
* :insiderHolders
* :netSharePurchaseActivity
* :earnings
* :earningsHistory
* :earningsTrend
* :industryTrend
* :indexTrend
* :sectorTrend
```

### Snapshot Example

```elixir
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
```

## Quote

Offers easy to use functions for getting a variety of real-time stock quotes.

#### Available quote functions do date:

- full_quote/1
- simple_quote/1
- custom_quote/2

Custom quote modules:

```elixir
* :ask
* :askSize
* :averageDailyVolume10Day
* :averageDailyVolume3Month
* :bid
* :bidSize
* :bookValue
* :currency
* :earningsTimestamp
* :earningsTimestampEnd
* :earningsTimestampStart
* :epsForward
* :epsTrailingTwelveMonths
* :esgPopulated
* :exchange
* :exchangeDataDelayedBy
* :exchangeTimezoneName
* :exchangeTimezoneShortName
* :fiftyDayAverage
* :fiftyDayAverageChange
* :fiftyDayAverageChangePercent
* :fiftyTwoWeekHigh
* :fiftyTwoWeekHighChange
* :fiftyTwoWeekHighChangePercent
* :fiftyTwoWeekLow
* :fiftyTwoWeekLowChange
* :fiftyTwoWeekLowChangePercent
* :fiftyTwoWeekRange
* :financialCurrency
* :forwardPE
* :fullExchangeName
* :gmtOffSetMilliseconds
* :language
* :longName
* :market
* :marketCap
* :marketState
* :messageBoardId
* :postMarketChange
* :postMarketChangePercent
* :postMarketPrice
* :postMarketTime
* :priceHint
* :priceToBook
* :quoteSourceName
* :quoteType
* :regularMarketChange
* :regularMarketChangePercent
* :regularMarketDayHigh
* :regularMarketDayLow
* :regularMarketDayRange
* :regularMarketOpen
* :regularMarketPreviousClose
* :regularMarketPrice
* :regularMarketTime
* :regularMarketVolume
* :sharesOutstanding
* :shortName
* :sourceInterval
* :symbol
* :tradeable
* :trailingPE
* :twoHundredDayAverage
* :twoHundredDayAverageChange
* :twoHundredDayAverageChangePercent
```

### Quote Example

```elixir
                         Symbol                   Modules
YahooFinance.custom_quote("FB", [:bid, :ask, :quoteType, :twoHundredDayAverage])

Output:
{:ok,
 {"FB",
  "{\"quoteResponse\":{\"result\":[{\"twoHundredDayAverage\":177.48935,
  \"quoteType\":\"EQUITY\",\"bid\":193.91,\"ask\":193.99}]}}"
  }
}
```
