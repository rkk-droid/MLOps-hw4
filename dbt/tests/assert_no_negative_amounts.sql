select
    transaction_time,
    merch,
    amount
from {{ ref('stg_transactions') }}
where amount < 0
