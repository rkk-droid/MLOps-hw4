{% macro rate_percent(numerator_sql, denominator_sql) %}
    round(
        coalesce(
            {{ dbt_utils.safe_divide(numerator_sql, denominator_sql) }},
            0
        ) * 100,
        4
    )
{% endmacro %}
