with royalty as (
    select
        DeviceId,
        LocationId,
        CustomerId,
        AgentId,
        AgentName,
        PaymentId,
        PaymentAmount,
        purchase_price,
        payment_order,
        payment_occurred_at as royalty_timestamp,
        payment_type
    from {{ ref('int__sales_payments') }}
    where payment_type = 'Royalty Payment'
)

select
    DeviceId,
    LocationId,
    CustomerId,
    AgentId,
    AgentName,
    PaymentId,
    try_to_number(PaymentAmount) as PaymentAmount,
    payment_order,
    royalty_timestamp,
    date_trunc('day', royalty_timestamp) as royalty_day,
    current_timestamp() as loaded_at
from royalty