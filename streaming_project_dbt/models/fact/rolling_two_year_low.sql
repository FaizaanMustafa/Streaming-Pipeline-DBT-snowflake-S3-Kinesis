with min_low as (

    select 
    ticker,
    round(min(low)) as min_low,
    from {{ref('yahoo_stocks_batch_data')}}
    where date >= current_date - (365*2)
    group by 1
),

include_dates as (
    select
    m.ticker,
    b.date,
    m.min_low
    from {{ref('yahoo_stocks_batch_data')}} b 
    inner join min_low m
    on  round(b.low) = round(m.min_low)
    and b.ticker = m.ticker
)

select * from include_dates