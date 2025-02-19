select
    CustomerId,
    CustomerName,
    CustomerEmail,
    CustomerPhoneNumber,
    LegalAddress,
    CustomerDateOfBirth,
    OccurredAt AS customer_registered_at
from {{ ref('stg__customer_snapshot') }}
where dbt_valid_to is null