/* This model aggregates monthly song plays per device and ties each device back to its agent by joining on the device allocation events. 
This way, you can see which agent is associated with each device's usage.
*/

with monthly_song_plays as (
    select
        DeviceId,
        date_trunc('month', OccurredAt) as usage_month,
        count(*) as total_song_plays
    from {{ ref('stg_events__music_songlistened') }}
    group by DeviceId, date_trunc('month', OccurredAt)
),
device_allocations as (
    select
        DeviceId,
        AgentId,
        AgentName,
        OccurredAt as allocation_occurred_at
    from {{ ref('stg_events__sale_deviceallocated') }}
)

select
    msp.DeviceId,
    da.AgentId,
    da.AgentName,
    msp.usage_month,
    msp.total_song_plays,
    current_timestamp() as loaded_at
from monthly_song_plays msp
left join device_allocations da
    on msp.DeviceId = da.DeviceId