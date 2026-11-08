with source_data as (
    select
        toDateTime(transaction_time) as transaction_time,
        trim(merch) as merch,
        trim(cat_id) as cat_id,
        toFloat64(amount) as amount,
        trim(name_1) as name_1,
        trim(name_2) as name_2,
        upper(trim(gender)) as gender,
        upper(trim(us_state)) as us_state,
        toFloat64(lat) as lat,
        toFloat64(lon) as lon,
        toFloat64(merchant_lat) as merchant_lat,
        toFloat64(merchant_lon) as merchant_lon,
        toUInt8(target) as target
    from {{ source('transactions_db', 'transactions') }}
),

enriched as (
    select
        transaction_time,
        toDate(transaction_time) as transaction_date,
        {{ dbt_date.date_part('hour', 'transaction_time') }} as hour_of_day,
        {{ dbt_date.date_part('dow', 'transaction_time') }} as day_of_week,
        merch,
        cat_id,
        amount,
        {{ amount_bucket('amount') }} as amount_bucket,
        {{ is_large_amount('amount') }} as is_large_transaction,
        name_1,
        name_2,
        gender,
        us_state,
        lat,
        lon,
        merchant_lat,
        merchant_lon,
        target,
        target as is_fraud,
        {{ dbt_utils.generate_surrogate_key([
            'name_1',
            'name_2',
            'lat',
            'lon'
        ]) }} as customer_id
    from source_data
)

select
    transaction_time,
    transaction_date,
    hour_of_day,
    day_of_week,
    {{ day_name('day_of_week') }} as day_name,
    merch,
    cat_id,
    amount,
    amount_bucket,
    is_large_transaction,
    name_1,
    name_2,
    gender,
    us_state,
    lat,
    lon,
    merchant_lat,
    merchant_lon,
    target,
    is_fraud,
    customer_id
from enriched
