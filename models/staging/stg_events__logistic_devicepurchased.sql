with
    source as (select * from {{ source("events", "LOGISTIC_DEVICEPURCHASED") }}),

    renamed as (select * from source)

select 
    variant_col:"DeviceId"::VARCHAR                    AS DeviceId,
    variant_col:"OccurredAt"::TIMESTAMP                AS OccurredAt,
    variant_col:"DeviceDetails"."DevicePrice"::VARCHAR AS DevicePrice,
    variant_col:"DeviceDetails"."DeviceTypeId"::VARCHAR AS DeviceTypeId,
    variant_col:"DeviceDetails"."DeviceTypeName"::VARCHAR AS DeviceTypeName,
    variant_col:"DeviceDetails"."SerialNumber"::VARCHAR AS SerialNumber
from renamed
