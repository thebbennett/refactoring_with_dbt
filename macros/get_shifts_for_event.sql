

{%- set event_shifts_sql -%}

select
    event_id,
    event_start_at

left join {{ ref('stg_mobilize_events_ie')}} events

  on rsvps.event_id = events.event_id

left join {{ ref('stg_mobilize_timeslots_ie')}} timeslots

  on rsvps.timeslot_id = timeslots.timeslot_id

{%- endset -%}

{#- Run this query, and load the results into memory -#}
{%- set event_shifts_results=run_query(event_shifts_sql) -%}

{#- Light transformation to make the results easier to work with -#}
{%- set event_shifts=event_shifts_results.rows -%}

{{ return(event_shifts) }}
