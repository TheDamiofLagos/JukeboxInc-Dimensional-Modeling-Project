-- A sale of a jukebox happens when a Device is allocated to a valid location and receives a payment in excess of the DevicePrice on the Customer’s account

/*
• Sales Qualification Model:
 – Created an intermediate model that joins Sale.DeviceAllocated with Sale.LocationRegistered and Sale.CustomerRegistered events.
 – Incorporated Payment.PaymentReceived data to categorize payment types
 - The payments CTE uses a window function to assign a payment order per customer, ensuring that the first payment is treated as the installation fee.
 – Included agent details (from the SellingAgent structure) so that each record has a clear lineage from event to business sale.
 – Added tests to confirm that every sale record has a valid device, customer, location, and payment associated.
*/
-- Testing 1234
-- models/int_sales_payments.sql

with allocated as (
    select
        DeviceId,
        LocationAllocatedId,
        OccurredAt as allocation_occurred_at,
        DevicePrice,
        AgentId,
        AgentName
    from {{ ref("stg_events__sale_deviceallocated") }}
),
customers as (
    select
        CustomerId,
        OccurredAt as customer_registered_at
    from {{ ref("stg__customer_snapshot") }}
    where dbt_valid_to is null -- to get most recent customer status
),
locations as (
    select
        LocationId,
        CustomerId,
        OccurredAt as location_registered_at
    from {{ ref("stg__location_snapshot") }}
    where dbt_valid_to is null -- to get most recent location status
),
device_purchase as (
    select
        DeviceId,
        DevicePrice as purchase_price,
        OccurredAt as purchase_occurred_at
    from {{ ref("stg_events__logistic_devicepurchased") }}
),
payments as (
    select
        PaymentId,
        CustomerId,
        PaymentAmount,
        OccurredAt as payment_occurred_at,
        row_number() over (
            partition by CustomerId
            order by OccurredAt
        ) as payment_order
    from {{ ref("stg_events__payment_paymentreceived") }}
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
    p.payment_order,
    /*
    For payment_order = 1, if the payment exceeds the purchase price, it's a Valid Sale.
    For payment_order = 1, if the payment is less than or equal to the purchase price, it's an Installation Installment (indicating a partial payment).
    Payments with payment_order > 1 are classified as Royalty Payment.


    */
    --REM: INCLUDE UNIT TEST FOR THIS BUSINESS LOGIC
    case 
       when p.payment_order = 1 
            and try_to_number(p.PaymentAmount) > try_to_number(dp.purchase_price)
            then 'Valid Sale'
       when p.payment_order = 1 
            and try_to_number(p.PaymentAmount) <= try_to_number(dp.purchase_price)
            then 'Installation Installment'
       when p.payment_order > 1 then 'Royalty Payment'
    end as payment_type
from allocated a
join locations l
    on a.LocationAllocatedId = l.LocationId
join customers c
    on l.CustomerId = c.CustomerId
join payments p
    on c.CustomerId = p.CustomerId
join device_purchase dp
    on a.DeviceId = dp.DeviceId
