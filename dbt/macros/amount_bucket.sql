{% macro amount_bucket(amount_expr) %}
    case
        when {{ amount_expr }} < {{ var('amount_small_lt') }} then 'small'
        when {{ amount_expr }} < {{ var('amount_medium_lt') }} then 'medium'
        when {{ amount_expr }} < {{ var('large_amount_threshold') }} then 'large'
        else 'xlarge'
    end
{% endmacro %}
