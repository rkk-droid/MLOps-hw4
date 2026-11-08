{{ config(
    engine='MergeTree()',
    order_by='(us_state)'
) }}

with by_state as (
    select
        us_state,
        count(*) as txn_count,
        sum(is_fraud) as fraud_count,
        {{ rate_percent('toFloat64(sum(is_fraud))', 'count(*)') }} as fraud_rate,
        sum(amount) as total_amount,
        sum(case when is_fraud = 1 then amount else 0 end) as fraud_amount,
        uniqExact(customer_id) as unique_customers,
        uniqExact(merch) as unique_merchants
    from {{ ref('stg_transactions') }}
    group by us_state
)

select
    by_state.us_state,
    states.state_name,
    by_state.txn_count,
    by_state.fraud_count,
    by_state.fraud_rate,
    by_state.total_amount,
    by_state.fraud_amount,
    by_state.unique_customers,
    by_state.unique_merchants
from by_state
left join {{ ref('us_states') }} as states
    on by_state.us_state = states.state_code
