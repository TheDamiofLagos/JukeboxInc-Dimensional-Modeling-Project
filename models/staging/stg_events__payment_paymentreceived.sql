with
    source as (select * from {{ source("events", "PAYMENT_PAYMENTRECEIVED") }}),

    renamed as (select * from source)

select
    variant_col:"Payment"."CustomerId"::VARCHAR AS CustomerId,
    variant_col:"Payment"."OccurredAt"::TIMESTAMP_TZ AS OccurredAt,
    variant_col:"Payment"."PaymentAmount"::NUMBER AS PaymentAmount,
    variant_col:"Payment"."PaymentId"::VARCHAR AS PaymentId 
from renamed
