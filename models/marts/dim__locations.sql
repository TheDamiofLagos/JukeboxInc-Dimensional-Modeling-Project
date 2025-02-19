select
    LocationId,
    CustomerId,
    Latitude,
    Longitude,
    ContactName,
    ContactPhoneNumber,
    OccurredAt as location_registered_at
from {{ ref('stg__location_snapshot') }}
where dbt_valid_to is null