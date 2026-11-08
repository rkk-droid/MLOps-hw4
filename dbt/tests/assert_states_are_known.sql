select
    us_state,
    state_name
from {{ ref('mart_fraud_by_state') }}
where state_name is null or state_name = ''
