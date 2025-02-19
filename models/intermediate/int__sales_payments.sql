with allocated as (
    select
        DeviceId,
        LocationAllocatedId,
        OccurredAt as allocation_occurred_at,
        DevicePrice,
        AgentId,
        AgentName
    from {{ref("stg_events__sale_deviceallocated")}}
),
customers as (
    select
        CustomerId,
        OccurredAt as customer_registered_at
    from {{ref("stg_events__sale_customerregistered")}}
),
locations as (
    select
        LocationId,
        CustomerId
    from {{ ref("stg_events__sale_locationregistered")}}
),
payments as (
    select
        PaymentId,
        CustomerId,
        PaymentAmount,
        OccurredAt as payment_occurred_at
    from {{ ref("stg_events__payment_paymentreceived") }}
),
device_purchase as (
    select
        DeviceId,
        DevicePrice as purchase_price,
        OccurredAt as purchase_occurred_at
    from {{ ref("stg_events__logistic_devicepurchased") }}
)

select
    a.DeviceId,
    l.LocationId,
    c.CustomerId,
    a.AgentId,
    a.AgentName,
    a.allocation_occurred_at,
    p.PaymentId,
    p.PaymentAmount,
    dp.purchase_price,
    case 
      when try_to_number(p.PaymentAmount) > try_to_number(dp.purchase_price) then 'Valid Sale'
      else 'Invalid Sale'
    end as sale_status
from allocated a
join locations l
    on a.LocationAllocatedId = l.LocationId
join customers c
    on l.CustomerId = c.CustomerId
join payments p
    on c.CustomerId = p.CustomerId
join device_purchase dp
    on a.DeviceId = dp.DeviceId
where try_to_number(p.PaymentAmount) > try_to_number(dp.purchase_price)