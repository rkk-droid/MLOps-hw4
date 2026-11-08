{{ config(
    engine='MergeTree()',
    order_by='(transaction_date, us_state)'
) }}

select
    transaction_date,
    us_state,
    count(*) as txn_count,
    sum(amount) as total_amount,
    avg(amount) as avg_amount,
    quantileExact(0.95) (amount) as p95_amount,
    sum(is_large_transaction) as large_txn_count,
    {{ rate_percent('toFloat64(sum(is_large_transaction))', 'count(*)') }}
        as large_txn_share
from {{ ref('stg_transactions') }}
group by
    transaction_date,
    us_state
