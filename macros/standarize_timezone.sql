{% macro standarize_timezone(column_name, timezone = 'America/NewYork') %}

{#-
We standarize timezones as America/New York timezones, including:

  - created_at
  - modified_at
  - deleted_at
  - loaded_at

We convert events to the timezone of the event location (Such as Mobilize events)

-#}

convert_timezone( '{{ timezone }}', {{ column_name }}::timestamp)

{%- endmacro %}
