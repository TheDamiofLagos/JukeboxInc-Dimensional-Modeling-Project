with
    source as (select * from {{ source("events", "SALE_LOCATIONREGISTERED") }}),

    renamed as (select * from source)

select
    variant_col:"ContactName"::VARCHAR AS ContactName,
    variant_col:"ContactPhoneNumber"::VARCHAR AS ContactPhoneNumber,
    variant_col:"CustomerId"::VARCHAR AS CustomerId,
    variant_col:"Latitude"::FLOAT AS Latitude,
    variant_col:"LocationId"::VARCHAR AS LocationId,
    variant_col:"Longitude"::FLOAT AS Longitude,
    TO_TIMESTAMP(variant_col:"OccurredAt"::VARCHAR, 'MM/DD/YYYY HH24:MI:SS.FF3') AS OccurredAt
from renamed
