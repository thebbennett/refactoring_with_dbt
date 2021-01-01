{% macro stage_mobilize_sms_opt_ins(schema_name) %}

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

  id as sms_opt_in_id,

  {{ standarize_timezone('created_date') }} as sms_opt_in_created_at,

  {{ standarize_timezone('modified_date') }} as sms_opt_in_modified_at,

  sms_opt_in_status,

  user_id,

  user__phone_number as phone,

  organization_id

  from {{ source( schema_name, 'sms_opt_ins') }}

  {%- endmacro %}
