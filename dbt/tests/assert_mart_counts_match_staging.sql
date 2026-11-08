with staging as (
    select
        count(*) as txn_count,
        sum(is_fraud) as fraud_count
    from {{ ref('stg_transactions') }}
),

fraud_marts as (
    select
        'mart_fraud_by_category' as mart_name,
        sum(txn_count) as txn_count,
        sum(fraud_count) as fraud_count
    from {{ ref('mart_fraud_by_category') }}

    union all

    select
        'mart_fraud_by_state' as mart_name,
        sum(txn_count) as txn_count,
        sum(fraud_count) as fraud_count
    from {{ ref('mart_fraud_by_state') }}

    union all

    select
        'mart_customer_risk_profile' as mart_name,
        sum(txn_count) as txn_count,
        sum(fraud_count) as fraud_count
    from {{ ref('mart_customer_risk_profile') }}

    union all

    select
        'mart_hourly_fraud_pattern' as mart_name,
        sum(txn_count) as txn_count,
        sum(fraud_count) as fraud_count
    from {{ ref('mart_hourly_fraud_pattern') }}

    union all

    select
        'mart_merchant_analytics' as mart_name,
        sum(txn_count) as txn_count,
        sum(fraud_count) as fraud_count
    from {{ ref('mart_merchant_analytics') }}
),

daily as (
    select sum(txn_count) as txn_count
    from {{ ref('mart_daily_state_metrics') }}
),

fraud_mismatches as (
    select fraud_marts.mart_name
    from fraud_marts
    cross join staging
    where
        fraud_marts.txn_count != staging.txn_count
        or fraud_marts.fraud_count != staging.fraud_count
),

daily_mismatches as (
    select 'mart_daily_state_metrics' as mart_name
    from daily
    cross join staging
    where daily.txn_count != staging.txn_count
)

select mart_name
from fraud_mismatches

union all

select mart_name
from daily_mismatches
