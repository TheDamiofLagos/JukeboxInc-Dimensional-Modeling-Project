/*
Created a model to handle cash outflow.
model aggregates transactions by a chosen period (here, monthly) and includes a simple reconciliation flag.
*/

with outflows as (
    select
        date_trunc('month', OccurredAt) as period,
        sum(try_to_number(DevicePrice)) as total_outflow,
        count(*) as num_purchases
    from {{ ref('stg_events__logistic_devicepurchased') }}
    group by date_trunc('month', OccurredAt)
)

select
    period,
    total_outflow,
    num_purchases,
    case 
       when total_outflow > 0 then 'OK'
       else 'Issue'
    end as reconciliation_flag,
    current_timestamp() as loaded_at
from outflows