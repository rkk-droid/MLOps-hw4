CREATE DATABASE IF NOT EXISTS transactions_db;

CREATE TABLE IF NOT EXISTS transactions_db.transactions
(
    transaction_time DateTime,
    merch String,
    cat_id String,
    amount Float64,
    name_1 String,
    name_2 String,
    gender String,
    us_state String,
    lat Float64,
    lon Float64,
    merchant_lat Float64,
    merchant_lon Float64,
    target UInt8
)
ENGINE = MergeTree
ORDER BY (transaction_time, merch, cat_id);

TRUNCATE TABLE transactions_db.transactions;

INSERT INTO transactions_db.transactions
SELECT
    parseDateTimeBestEffort(transaction_time) AS transaction_time,
    merch,
    cat_id,
    amount,
    name_1,
    name_2,
    gender,
    us_state,
    lat,
    lon,
    merchant_lat,
    merchant_lon,
    target
FROM file(
    'train.csv',
    'CSVWithNames',
    'transaction_time String, merch String, cat_id String, amount Float64, name_1 String, name_2 String, gender String, street String, one_city String, us_state String, post_code String, lat Float64, lon Float64, population_city String, jobs String, merchant_lat Float64, merchant_lon Float64, target UInt8'
)
SETTINGS
    input_format_csv_trim_whitespaces = 1,
    input_format_null_as_default = 1;

SELECT throwIf(
    (SELECT count() FROM transactions_db.transactions) != 786431,
    'Expected 786431 rows in transactions_db.transactions'
);
