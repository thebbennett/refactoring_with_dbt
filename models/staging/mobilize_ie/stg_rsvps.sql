with

event_timezone as (

  select

    id as event_id,

    timezone

  from {{ source('sun_mobilize', 'events') }}



), staged_rsvps as ()

  select

    id as rsvp_id,

    convert_timezone('UTC', 'America/New_York', created_date) as created_at,

    convert_timezone('UTC', 'America/New_York', modified_date) as modified_at,

    user_id,

    user__modified_date

    user__given_name as first_name,

    user__family_name as last_name,

    user__email_address as email,

    user__phone_number as phone,

    user__postal_code as zip,

    user__blocked_date,

    event_id,

    event_type,

    timeslot_id,

    -- change event start and end times to be in the timezone of the event
    convert_timezone('UTC', event_timezone.timezone, start_date) as event_start_at,

    convert_timezone('UTC', event_timezone.timezone, end_date) as event_end_at,

    override_start_date,

    override_end_date,

    organization_id,

    organization__name,

    organization__slug,

    affiliation_id,

    affiliation__name,

    affiliation__slug,

    status,

    attended,

    experience_feedback_type,

    experience_feedback_text,

    referrer__utm_source as utm_source,

    referrer__utm_medium as utm_medium,

    referrer__utm_campaign as utm_campagin,

    referrer__utm_term as utm_term,

    referrer__utm_content as utm_content,

    referrer__url,

    email_at_signup,

    given_name_at_signup, as first_name_at_signup,

    family_name_at_signup as last_name_at_signup,

    phone_number_at_signup as phone_at_signup,

    postal_code_at_signup as zip_at_signup,

    custom_field_values,

    event_type_name


  from {{ source('sun_mobilize', 'participations')}}

  left join event_timezone using(event_id)

) select * from staged_rsvps