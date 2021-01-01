-- Each row correpsonds to a shift sign up in the IE Mobilize committee  for our 2021 GA runoff vote tripling events
-- The status fields can be: REGISTRED, CONFIRMED, CANCELLED
-- We do not remove Cancelled shifts. These data sync to a Google Spreadsheet and organizers need to see when a volunteer has cancelled.
-- One custom question was set up for the Mobilize sign up to ask volunteers if they want to be a Vote Tripling Captain

with

base as (

  select

    rsvp_id,

    first_name,

    last_name,

    email,

    phone,

    event_name,

    event_id,

    status,

    replace(replace(rsvps.custom_field_values, '[',''), ']', '') as questions,

    rsvp_created_at,

    event_start_at,

    event_end_at,

    -- duplicates exists in the table due to error in loading script
    row_number() over (partition by part.id order by rsvps.rsvp_created_at::timestamp desc) = 1 as is_most_recent

  from  {{ ref('stg_mobilize_rsvps_ie')}} rsvps

  left join {{ ref('stg_mobilize_events_ie')}} events

    on rsvps.event_id = events.event_id

  left join {{ ref('stg_mobilize_timeslots_ie')}} timeslots

    on rsvps.timeslot_id = timeslots.timeslot_id

   where

    events.event_name ilike '%Vote Tripling%'

    and events.event_created_at::date > '2020-12-15'::date

), de_dup as (

  	select * from base where is_most_recent

), vote_tripling_shifts as (

  select

    signup_date,

    id,

    first_name,

    last_name,

    email,

    phone,

    case

      when email = 'avalindosmvmt@gmail.com' then 'Roswell' -- hard code bad RSVP, switch to different location

      when event_name ilike '%Clayton%' then 'Clayton County'

      when event_name ilike '%Dekalb%'  then 'Dekalb County'

      when event_name ilike '%Cobb%'  then 'Cobb County'

      when event_name ilike '%Decatur%'  then 'Decatur'

      when event_name ilike '%Roswell%'  then 'Roswell'

      when event_name ilike '%Gwinnett%'  then 'Gwinnett'

      when event_name ilike '%ATL%'  then 'ATL'

      else null end as event_location,

    event_start_at::date as shift_day,

    case

      when extract(hour from event_start_at::timestamp) > 12 then

        to_char(event_start_at::timestamp, 'HH:MI AM') else

      to_char(event_start_at::timestamp, 'HH:MI PM') end as shift_start_time,

    case

      when extract(hour from event_end_at::timestamp) > 12 then

        to_char(event_end_at::timestamp, 'HH:MI AM') else

      to_char(event_end_at::timestamp, 'HH:MI PM') end as shift_end_time,

    json_extract_path_text(questions, 'boolean_value') as is_captain,

    status

  from de_dup

  order by 1 asc nulls last

) select * from vote_tripling_shifts
