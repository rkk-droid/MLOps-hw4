select
    customer_id,
    fraud_rate,
    risk_segment
from {{ ref('mart_customer_risk_profile') }}
where
    (
        risk_segment = 'HIGH'
        and fraud_rate < {{ var('high_risk_fraud_rate') }}
    )
    or (
        risk_segment = 'MEDIUM'
        and (
            fraud_rate < {{ var('medium_risk_fraud_rate') }}
            or fraud_rate >= {{ var('high_risk_fraud_rate') }}
        )
    )
    or (
        risk_segment = 'LOW'
        and fraud_rate >= {{ var('medium_risk_fraud_rate') }}
    )
    or risk_segment not in ('HIGH', 'MEDIUM', 'LOW')
