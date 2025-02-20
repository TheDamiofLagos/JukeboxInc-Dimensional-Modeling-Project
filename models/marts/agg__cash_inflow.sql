/*
Created a model to handle cash inflow.
model aggregates transactions by a chosen period (here, monthly) and includes a simple reconciliation flag.
*/

with inflows as (
    select
        date_trunc('month', OccurredAt) as period,
        sum(try_to_number(PaymentAmount)) as total_inflow,
        count(*) as num_payments
    from {{ ref('stg_events__payment_paymentreceived') }}
    group by date_trunc('month', OccurredAt)
)

select
    period,
    total_inflow,
    num_payments,
    case 
       when total_inflow > 0 then 'OK'
       else 'Issue'
    end as reconciliation_flag,
    current_timestamp() as loaded_at
from inflows