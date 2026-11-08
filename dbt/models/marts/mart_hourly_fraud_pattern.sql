{{ config(
    engine='MergeTree()',
    order_by='(day_of_week, hour_of_day)'
) }}

with transactions as (
    select
        day_of_week,
        day_name,
        hour_of_day,
        is_fraud,
        amount
    from {{ ref('stg_transactions') }}
),

by_slot as (
    select
        day_of_week,
        any(day_name) as day_name,
        hour_of_day,
        count(*) as txn_count,
        sum(is_fraud) as fraud_count,
        sum(amount) as total_amount,
        {{ rate_percent('toFloat64(sum(is_fraud))', 'count(*)') }} as fraud_rate
    from transactions
    group by
        day_of_week,
        hour_of_day
),

overall as (
    select
        {{ rate_percent('toFloat64(sum(is_fraud))', 'count(*)') }}
            as overall_fraud_rate
    from transactions
)

select
    by_slot.day_of_week,
    by_slot.day_name,
    by_slot.hour_of_day,
    by_slot.txn_count,
    by_slot.fraud_count,
    by_slot.total_amount,
    by_slot.fraud_rate,
    overall.overall_fraud_rate,
    case
        when
            by_slot.fraud_rate
            >= overall.overall_fraud_rate
            * {{ var('elevated_risk_multiplier') }}
            then 1
        else 0
    end as is_elevated_risk
from by_slot
cross join overall
