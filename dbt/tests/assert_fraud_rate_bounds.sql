select
    'mart_fraud_by_category' as mart_name,
    toString(cat_id) as grain,
    fraud_rate
from {{ ref('mart_fraud_by_category') }}
where fraud_rate > 100 or fraud_rate < 0

union all

select
    'mart_fraud_by_state' as mart_name,
    toString(us_state) as grain,
    fraud_rate
from {{ ref('mart_fraud_by_state') }}
where fraud_rate > 100 or fraud_rate < 0

union all

select
    'mart_customer_risk_profile' as mart_name,
    toString(customer_id) as grain,
    fraud_rate
from {{ ref('mart_customer_risk_profile') }}
where fraud_rate > 100 or fraud_rate < 0

union all

select
    'mart_hourly_fraud_pattern' as mart_name,
    concat(toString(day_of_week), '-', toString(hour_of_day)) as grain,
    fraud_rate
from {{ ref('mart_hourly_fraud_pattern') }}
where fraud_rate > 100 or fraud_rate < 0

union all

select
    'mart_merchant_analytics' as mart_name,
    toString(merch) as grain,
    fraud_rate
from {{ ref('mart_merchant_analytics') }}
where fraud_rate > 100 or fraud_rate < 0
