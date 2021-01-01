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

    replace(replace(part.custom_field_values, '[',''), ']', '') as questions,

    rsvp_created_at,

    event_start_at,

    event_end_at,

    -- duplicates exists in the table due to error in loading script
    row_number() over (partition by part.id order by part.created_date::date desc) = 1 as is_most_recent

  from  {{ ref('stg_mobilize_rsvps_c4')}} rsvps

  left join {{ ref('stg_mobilize_events_c4')}} events

    on part.event_id = events.event_id

  left join {{ ref('stg_mobilize_timeslots_c4')}} timeslots

    on timeslots.timeslot_id = part.timeslot_id

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


 ), summary as (

   select

   event_location as hub,
   sum(case when shift_day = '2020-12-29'::date then 1 end) as tuesday_12_29_shifts,
   sum(case when shift_day = '2020-12-30'::date then 1 end) as wednesday_12_30_shifts,
   sum(case when shift_day = '2020-12-31'::date then 1 end) as thursday_12_31_shifts,
   sum(case when shift_day = '2021-01-05'::date
       and shift_start_time = '07:00 AM' then 1 end) as e_day_01_05_shift_7am,
   sum(case when shift_day = '2021-01-05'::date
       and shift_start_time = '11:00 AM' then 1 end) as  e_day_01_05_shift_11am,
   sum(case when shift_day = '2021-01-05'::date
       and shift_start_time = '03:00 PM' then 1 end) as e_day_01_05_shift_3pm



   from final

   where status != 'CANCELLED'

   group by 1

   ) select * from summary
