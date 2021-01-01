with

base as (

  select
    part.id,
    part.user__given_name as first_name,
    part.user__family_name as last_name,
    part.user__email_address  as email,
    part.user__phone_number as phone,
    events.title as event_name,
  	part.event_id,
  	part.status,
  	convert_timezone('EST', part.created_date::timestamp) as signup_date,
    convert_timezone('EST', timeslots.start_date::timestamp) as shift_start_date,
    convert_timezone('EST', timeslots.end_date::timestamp) as shift_end_date,
    row_number() over (partition by part.id order by part.created_date::date desc) = 1 as is_most_recent

  from  sun_mobilize.participations part

  left join sun_mobilize.events events
  	on part.event_id = events.id

  left join sun_mobilize.timeslots timeslots
  	on timeslots.id = part.timeslot_id

   where events.title ilike '%Vote Tripling%'
  			and events.created_date::date > '2020-12-15'::date

), de_dup as (

  	select * from base where is_most_recent

), final as (

  select
      signup_date,
  		id,
  		first_name,
      last_name,
      email,
  		phone,
      case 	when email = 'avalindosmvmt@gmail.com' then 'Roswell'
            when event_name ilike '%Clayton%' then 'Clayton County'
            when event_name ilike '%Dekalb%'  then 'Dekalb County'
            when event_name ilike '%Cobb%'  then 'Cobb County'
            when event_name ilike '%Decatur%'  then 'Decatur'
            when event_name ilike '%Roswell%'  then 'Roswell'
            when event_name ilike '%Gwinnett%'  then 'Gwinnett'
            when event_name ilike '%ATL%'  then 'ATL'
  					else null end as event_location,
      shift_start_date::date as shift_day,
      case 	when extract(hour from shift_start_date::timestamp) > 12 then
      	to_char(shift_start_date::timestamp, 'HH:MI AM') else
      	to_char(shift_start_date::timestamp, 'HH:MI PM') end as shift_start_time,
      case 	when extract(hour from shift_end_date::timestamp) > 12 then
      	to_char(shift_end_date::timestamp, 'HH:MI AM') else
      	to_char(shift_end_date::timestamp, 'HH:MI PM') end as shift_end_time,
  	status

  from de_dup
  order by signup_date asc nulls last

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
