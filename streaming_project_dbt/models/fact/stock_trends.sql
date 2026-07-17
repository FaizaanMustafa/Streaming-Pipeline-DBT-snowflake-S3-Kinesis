with hourly_data as (
    select distinct symbol,
    year(timestamp) as year,
    month(timestamp) as month,
    day(timestamp) as day,
    hour(timestamp) as hour,
    open,
    high,
    low,
    close
    from {{ref('yahoo_stocks_streaming_data')}}

),

previous_open_calc as (
    select *,
    case 
        when previous_open_same_day is not null then
            case
                when open > previous_open_same_day then 'BEARISH'
                when open < previous_open_same_day then 'BULLISH'
                else 'SIDEWAYS'
            end
        else
            case 
                when open > previous_open_diff_day then 'BEARISH'
                when open < previous_open_diff_day then 'BULLISH'
                else 'SIDEWAYS'
            end
        end as stock_status
    from 
        (
            select *,
                lag(open) over (partition by symbol order by global_rank asc) as previous_open_diff_day
            from 
                (select *,
                lag(open) over (partition by symbol,month,day order by hour asc) as previous_open_same_day,
                row_number() over (partition by symbol order by year asc, month asc,day asc,hour asc) as global_rank
                from hourly_data
                )
        )
)

select *
    exclude(previous_open_same_day,previous_open_diff_day,global_rank,stock_status),
    case 
        when previous_open_same_day is null  and previous_open_diff_day is null  then 'UNCLASSIFIED'
        else stock_status
    end as stock_status
from previous_open_calc
order by symbol asc,year asc,day asc,hour asc