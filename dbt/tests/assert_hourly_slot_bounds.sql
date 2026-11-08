select
    day_of_week,
    hour_of_day
from {{ ref('mart_hourly_fraud_pattern') }}
where
    hour_of_day < 0
    or hour_of_day > 23
    or day_of_week < 0
    or day_of_week > 6
