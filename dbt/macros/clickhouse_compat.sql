{% macro clickhouse__concat(fields) -%}
    concat({{ fields | join(', ') }})
{%- endmacro %}
