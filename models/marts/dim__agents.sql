select distinct
    AgentId,
    AgentName
from {{ ref('stg_events__sale_deviceallocated') }}