with
    source as (select * from {{ source("events", "MUSIC_SONGLISTENED") }}),

    renamed as (select * from source)

select 
    variant_col:"DeviceId"::NUMBER           AS DeviceId,
    variant_col:"OccurredAt"::TIMESTAMP_TZ     AS OccurredAt,
    variant_col:"SongCompletedTime"::NUMBER    AS SongCompletedTime,
    variant_col:"SongId"::NUMBER               AS SongId
from renamed
