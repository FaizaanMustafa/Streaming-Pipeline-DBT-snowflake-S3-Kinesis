
select  date, ticker, {{round('open', 2)}} as open, {{round('high', 2)}} as high, {{round('low', 2)}} as low, {{round('close', 2)}} as close, volume
from {{source('snowflake_source', 'BATCH_DATA_STOCKS')}}
