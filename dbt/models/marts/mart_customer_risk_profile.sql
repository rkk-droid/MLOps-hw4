{{ config(
    engine='MergeTree()',
    order_by='(customer_id)'
) }}

with customers as (
    select
        customer_id,
        any(name_1) as name_1,
        any(name_2) as name_2,
        any(us_state) as us_state,
        count(*) as txn_count,
        sum(is_fraud) as fraud_count,
        sum(amount) as total_amount,
        avg(amount) as avg_amount,
        min(transaction_time) as first_transaction_time,
        max(transaction_time) as last_transaction_time,
        {{ rate_percent('toFloat64(sum(is_fraud))', 'count(*)') }} as fraud_rate
    from {{ ref('stg_transactions') }}
    group by customer_id
)

select
    customer_id,
    name_1,
    name_2,
    us_state,
    txn_count,
    fraud_count,
    total_amount,
    avg_amount,
    fraud_rate,
    first_transaction_time,
    last_transaction_time,
    {{ risk_segment('fraud_rate') }} as risk_segment
from customers
