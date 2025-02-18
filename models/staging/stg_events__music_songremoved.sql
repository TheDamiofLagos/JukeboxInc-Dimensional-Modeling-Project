with
    source as (select * from {{ source("events", "MUSIC_SONGREMOVED") }}),

    renamed as (select * from source)

select
        variant_col:"OccurredAt"::TIMESTAMP_TZ              AS OccurredAt,
    variant_col:"SongId"::VARCHAR      AS SongId    
from renamed
