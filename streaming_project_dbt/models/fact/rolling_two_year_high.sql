with max_high as (

    select 
    ticker,
    round(max(high)) as max_high,
    from {{ref('yahoo_stocks_batch_data')}}
    where date >= current_date - (365*2)
    group by 1
),

include_dates as (
    select
    m.ticker,
    b.date,
    m.max_high
    from {{ref('yahoo_stocks_batch_data')}} b 
    inner join max_high m
    on  round(b.high) = round(m.max_high)
    and b.ticker = m.ticker
)

select * from include_dates