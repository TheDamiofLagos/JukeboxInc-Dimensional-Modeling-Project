with
    source as (select * from {{ source("events", "SALE_CUSTOMERREGISTERED") }}),

    renamed as (select * from source)

select
        TO_DATE(variant_col:"CustomerDateOfBirth"::VARCHAR, 'MM/DD/YYYY') AS CustomerDateOfBirth,
  variant_col:"CustomerEmail"::VARCHAR AS CustomerEmail,
  variant_col:"CustomerId"::VARCHAR AS CustomerId,
  variant_col:"CustomerIdentityNumber"::VARCHAR AS CustomerIdentityNumber,
  variant_col:"CustomerName"::VARCHAR AS CustomerName,
  variant_col:"CustomerPhoneNumber"::VARCHAR AS CustomerPhoneNumber,
  variant_col:"LegalAddress"::VARCHAR AS LegalAddress,
  TO_TIMESTAMP(variant_col:"OccurredAt"::VARCHAR, 'MM/DD/YYYY HH24:MI:SS.FF3') AS OccurredAt
from renamed
