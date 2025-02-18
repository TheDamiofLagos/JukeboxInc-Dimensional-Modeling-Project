with
    source as (select * from {{ source("events", "SALE_LOCATIONREGISTERED") }}),

    renamed as (select * from source)

select
    variant_col:"DeviceId"::VARCHAR AS DeviceId,
    variant_col:"LocationAllocatedId"::VARCHAR AS LocationAllocatedId,
    TO_TIMESTAMP(variant_col:"OccurredAt"::VARCHAR, 'MM/DD/YYYY HH24:MI:SS.FF3') AS OccurredAt,
    variant_col:"DeviceDetails"."DeviceName"::VARCHAR AS DeviceName,
    variant_col:"DeviceDetails"."DevicePrice"::VARCHAR AS DevicePrice,
    variant_col:"DeviceDetails"."Id"::VARCHAR AS DeviceDetailsId,
    variant_col:"SellingAgent"."AgentId"::VARCHAR AS AgentId,
    variant_col:"SellingAgent"."AgentName"::VARCHAR AS AgentName
from renamed
