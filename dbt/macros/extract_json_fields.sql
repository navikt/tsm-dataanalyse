

{% macro extract_json_fields(column, mappings) %}

    {%- for mapping in mappings %}

        json_extract_scalar({{ column }}, '$.{{ mapping.key }}') as {{ mapping.name }}

        {%- if not loop.last %},{% endif %}

    {%- endfor %}

{% endmacro %}
