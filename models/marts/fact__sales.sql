-- models/fact_sales.sql

with valid_sales as (
    select
        DeviceId,
        LocationId,
        CustomerId,
        AgentId,
        AgentName,
        allocation_occurred_at as sale_timestamp,
        PaymentId,
        PaymentAmount,
        purchase_price,
        try_to_number(PaymentAmount) - try_to_number(purchase_price) as margin
    from {{ ref('int__sales_payments') }}
    where payment_type = 'Valid Sale'
)

select
    DeviceId,
    LocationId,
    CustomerId,
    AgentId,
    AgentName,
    sale_timestamp,
    PaymentId,
    PaymentAmount,
    purchase_price,
    margin,
    date_trunc('day', sale_timestamp) as sale_day,
    current_timestamp() as loaded_at
from valid_sales
