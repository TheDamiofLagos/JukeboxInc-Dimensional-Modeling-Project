/*
This model is designed for marketing insights. It joins the fact_sales table (which contains only valid installation sales) to the device dimension to obtain product information. 
The query then aggregates sales by product type and by month, enabling us to compare performance across product launches.
*/

with sales_with_product as (
    select
        fs.DeviceId,
        fs.CustomerId,
        fs.AgentId,
        fs.sale_timestamp,
        fs.PaymentAmount,
        ds.DeviceTypeName as product_name,
        date_trunc('month', fs.sale_timestamp) as sale_month
    from {{ ref('fact__sales') }} fs
    join {{ ref('dim__devices') }} ds
      on fs.DeviceId = ds.DeviceId
)

select
    product_name,
    sale_month,
    count(*) as total_sales,
    sum(try_to_number(PaymentAmount)) as total_revenue,
    current_timestamp() as loaded_at
from sales_with_product
group by product_name, sale_month
order by sale_month, product_name