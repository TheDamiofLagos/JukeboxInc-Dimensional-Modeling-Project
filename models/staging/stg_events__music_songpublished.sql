with
    source as (select * from {{ source("events", "MUSIC_SONGPUBLISHED") }}),

    renamed as (select * from source)

select 
    variant_col:"OccurredAt"::TIMESTAMP_TZ              AS OccurredAt,
    variant_col:"SongDetails"."AlbumName"::VARCHAR       AS AlbumName,
    variant_col:"SongDetails"."ArtistName"::VARCHAR      AS ArtistName,
    variant_col:"SongDetails"."SongLength"::VARCHAR      AS SongLength,
    variant_col:"SongDetails"."SongName"::VARCHAR        AS SongName,
    variant_col:"SongDetails"."SongSizeMb"::FLOAT        AS SongSizeMb,
    variant_col:"SongId"::NUMBER                         AS SongId
from renamed
