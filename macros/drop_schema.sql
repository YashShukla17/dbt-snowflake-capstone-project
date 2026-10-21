{% macro drop_schema(schema_name) %}

 {% if schema_name %}
    {{ log('dropping the schema:- '~schema_name, info=true ) }}

    {% set drop_query %}
      drop schema if exists {{ target.database }}.{{ schema_name }} CASCADE;
    {% endset %}

    {% do run_query(drop_query)  %}

    {{ log('execution completed, dropped schema:- '~schema_name, info=True) }}
 {% else %}
     {{ log('no schema name provided, skipped cleanup '~schema_name, info=True) }}
 {% endif %}



{% endmacro %}