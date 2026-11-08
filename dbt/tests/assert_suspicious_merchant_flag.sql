select
    merch,
    fraud_rate,
    txn_count,
    is_suspicious
from {{ ref('mart_merchant_analytics') }}
where
    (
        is_suspicious = 1
        and (
            fraud_rate < {{ var('suspicious_fraud_rate') }}
            or txn_count < {{ var('suspicious_min_txn') }}
        )
    )
    or (
        is_suspicious = 0
        and fraud_rate >= {{ var('suspicious_fraud_rate') }}
        and txn_count >= {{ var('suspicious_min_txn') }}
    )
    or is_suspicious not in (0, 1)
