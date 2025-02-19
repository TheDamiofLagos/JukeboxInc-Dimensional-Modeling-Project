select
    DeviceId,
    DeviceTypeId,
    DeviceTypeName,
    SerialNumber,
    DevicePrice,
    OccurredAt as device_purchase_date
from {{ ref('stg_events__logistic_devicepurchased') }}