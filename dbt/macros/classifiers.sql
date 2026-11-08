{% macro is_large_amount(amount_expr) %}
    case
        when {{ amount_expr }} >= {{ var('large_amount_threshold') }} then 1
        else 0
    end
{% endmacro %}

{% macro day_name(dow_expr) %}
    case {{ dow_expr }}
        when 0 then 'Sunday'
        when 1 then 'Monday'
        when 2 then 'Tuesday'
        when 3 then 'Wednesday'
        when 4 then 'Thursday'
        when 5 then 'Friday'
        when 6 then 'Saturday'
        else 'Unknown'
    end
{% endmacro %}

{% macro risk_segment(fraud_rate_expr) %}
    case
        when {{ fraud_rate_expr }} >= {{ var('high_risk_fraud_rate') }} then 'HIGH'
        when {{ fraud_rate_expr }} >= {{ var('medium_risk_fraud_rate') }} then 'MEDIUM'
        else 'LOW'
    end
{% endmacro %}

{% macro is_suspicious_merchant(fraud_rate_expr, txn_count_expr) %}
    case
        when {{ fraud_rate_expr }} >= {{ var('suspicious_fraud_rate') }}
            and {{ txn_count_expr }} >= {{ var('suspicious_min_txn') }}
            then 1
        else 0
    end
{% endmacro %}
