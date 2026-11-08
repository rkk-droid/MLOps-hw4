{{ config(
    engine='MergeTree()',
    order_by='(cat_id)'
) }}

select
    cat_id,
    count(*) as txn_count,
    sum(is_fraud) as fraud_count,
    {{ rate_percent('toFloat64(sum(is_fraud))', 'count(*)') }} as fraud_rate,
    sum(amount) as total_amount,
    sum(case when is_fraud = 1 then amount else 0 end) as fraud_amount,
    avg(amount) as avg_amount
from {{ ref('stg_transactions') }}
group by cat_id
