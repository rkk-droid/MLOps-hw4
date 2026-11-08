{{ config(
    engine='MergeTree()',
    order_by='(merch)'
) }}

with merchants as (
    select
        merch,
        count(*) as txn_count,
        sum(amount) as turnover,
        avg(amount) as avg_amount,
        sum(is_fraud) as fraud_count,
        {{ rate_percent('toFloat64(sum(is_fraud))', 'count(*)') }} as fraud_rate,
        uniqExact(customer_id) as unique_customers,
        uniqExact(cat_id) as category_count
    from {{ ref('stg_transactions') }}
    group by merch
)

select
    merch,
    txn_count,
    turnover,
    avg_amount,
    fraud_count,
    fraud_rate,
    unique_customers,
    category_count,
    {{ is_suspicious_merchant('fraud_rate', 'txn_count') }} as is_suspicious
from merchants
