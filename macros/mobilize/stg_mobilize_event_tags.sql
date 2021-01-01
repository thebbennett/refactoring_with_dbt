{% macro stage_mobilize_event_tags(schema_name) %}

{#-

Sunrise has 3 Mobilize committees:

    Mobilize Com.         Designation   Schema
    _____________________________________________________________
    | Sunrise           | IE           |  sun_mobilize          |
    |___________________|______________|________________________|
    | Sunrise 2020      | Coordinated  |  sunrise2020_mobilize  |
    |___________________|______________|________________________|
    | Sunrise Movement  | c4           |  sunrise_mobilize      |
    |___________________|______________|________________________|
-#}

select

  id as event_tag_id,

  {{ standarize_timezone('created_date') }} as event_tag_created_at,

  {{ standarize_timezone('modified_date') }} as event_tag_modified_at,

  {{ standarize_timezone('deleted_date') }} as event_tag_deleted_at,

  event_id


from {{ source( schema_name, 'event_tags') }}


{%- endmacro %}
