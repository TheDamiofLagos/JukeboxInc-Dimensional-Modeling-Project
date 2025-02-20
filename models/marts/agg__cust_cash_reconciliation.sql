/*
Built a reconciliation model that aggregates customer‐level data from sales, royalty payments, 
and usage to compare actual cash received against what’s expected (the installation fee plus an estimated royalty revenue). 
Here, we assume a constant royalty rate (e.g. $0.10 per song played). You can adjust that rate as needed.

The logic works as follows:

Installation Fee:
– Group by customer in the fact_sales table to get the sum of valid installation payments.

Royalty (Actual):
– Group by customer in the fact_royalty table to sum up all recurring (royalty) payments.

Usage & Expected Royalty:
– Join fact_usage (aggregated monthly song plays per device) to a device-to-customer mapping (from fact_sales) so that you can aggregate total song plays per customer.
– Multiply the total song plays by a fixed royalty rate (e.g., $0.10 per song) to get the expected royalty revenue.

Final Reconciliation:
– Join these components (installation fee, actual royalty, expected royalty) at the customer level (using your dim_customers) and compute both actual total received and expected total.
– Finally, calculate the reconciliation difference (actual minus expected).
*/


with installation as (
    -- Sum of valid installation payments per customer from fact_sales.
    select
        CustomerId,
        sum(PaymentAmount) as installation_fee
    from {{ ref('fact__sales') }}
    group by CustomerId
),
royalty_actual as (
    -- Sum of actual royalty payments per customer from fact_royalty.
    select
        CustomerId,
        sum(PaymentAmount) as actual_royalty
    from {{ ref('fact__royalty') }}
    group by CustomerId
),
device_customer as (
    -- Map each device to its customer using fact_sales.
    select distinct
        DeviceId,
        CustomerId
    from {{ ref('fact__sales') }}
),
usage_agg as (
    -- Aggregate total song plays per customer.
    select
        dc.CustomerId,
        sum(total_song_plays) as total_song_plays
    from {{ ref('agg__usage') }} fu
    join device_customer dc on fu.DeviceId = dc.DeviceId
    group by dc.CustomerId
),
reconciliation as (
    select
        c.CustomerId,
        c.CustomerName,
        coalesce(inst.installation_fee, 0) as actual_installation,
        coalesce(roy.actual_royalty, 0) as actual_royalty,
        (coalesce(inst.installation_fee, 0) + coalesce(roy.actual_royalty, 0)) as actual_total,
        coalesce(inst.installation_fee, 0) as expected_installation,
        coalesce(u.total_song_plays, 0) * 0.10 as expected_royalty,
        (coalesce(inst.installation_fee, 0) + coalesce(u.total_song_plays, 0) * 0.10) as expected_total,
        (
          (coalesce(inst.installation_fee, 0) + coalesce(roy.actual_royalty, 0)) -
          (coalesce(inst.installation_fee, 0) + coalesce(u.total_song_plays, 0) * 0.10)
        ) as reconciliation_diff,
        current_timestamp() as loaded_at
    from {{ ref('dim__customers') }} c
    left join installation inst on c.CustomerId = inst.CustomerId
    left join royalty_actual roy on c.CustomerId = roy.CustomerId
    left join usage_agg u on c.CustomerId = u.CustomerId
)

select *
from reconciliation
order by CustomerId