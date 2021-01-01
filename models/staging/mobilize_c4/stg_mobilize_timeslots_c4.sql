with

event_timezone as (

  select

    participations.timeslot_id,

    events.timezone

  from {{ source('sunrise_mobilize', 'participations') }} participations

  left join {{ source ('sunrise_mobilize', 'events')}} events

    on  participations.event_id = events.id


), timeslots as (select


    id as timeslot_id,

    -- change event start and end times to be in the timezone of the event
    convert_timezone(event_timezone.timezone, start_date::timestamp) as event_start_at,

    convert_timezone(event_timezone.timezone, end_date::timestamp) as event_end_at,

    {{ standarize_timezone('created_date') }} as timeslot_created_at,

    {{ standarize_timezone('modified_date') }} as timeslot_modified_at,

    {{ standarize_timezone('deleted_date') }} as timeslot_deleted_at,

    max_attendees


  from {{ source('sunrise_mobilize', 'timeslots')}} timeslot

  left join event_timezone

    on event_timezone.timeslot_id = timeslot.id

) select * from timeslots
