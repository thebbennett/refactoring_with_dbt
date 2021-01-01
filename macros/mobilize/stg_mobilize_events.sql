{% macro stage_mobilize_events(schema_name) %}

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

  id as event_id,

  title as event_name,

  summary,

  description,

  featured_image_url,

  high_priority as is_high_priority,

  organization_id,

  organization__name,

  organization__slug,

  organization__is_coordinated,

  organization__is_independent,

  organization__race_type,

  organization__is_primary_campaign,

  organization__state,

  organization__district,

  organization__candidate_name,

  organization__modified_date,

  location__is_private,

  location__venue,

  location__address_line_1,

  location__address_line_2,

  location__locality,

  location__region,

  location__country,

  location__postal_code,

  location__lat,

  location__lon,

  location__modified_date,

  location__congressional_district,

  location__state_leg_district,

  location__state_senate_district,

  timezone,

  event_type,

  browser_url,

  {{ standarize_timezone('created_date') }} as event_created_at,

  {{ standarize_timezone('modified_date') }} as event_modified_at,

  {{ standarize_timezone('deleted_date') }} as event_deleted_at,

  visibility,

  created_by_volunteer_host,

  van_name,

  contact__name,

  contact__email_address,

  contact__phone_number,

  approval_status,

  rejection_message,

  referrer__utm_source as utm_source,

  referrer__utm_medium as utm_medium,

  referrer__utm_campaign as utm_campaign,

  referrer__utm_term as utm_term,

  referrer__utm_content as utm_content,

  referrer__url,

  owner_id,

  owner__modified_date,

  owner__given_name as owner_first_name,

  owner__family_name as owner_last_name,

  owner__email_address as owner_email,

  owner__phone_number as owner_phone,

  owner__postal_code as owner_zip,

  creator_id,

  creator__modified_date,

  creator__family_name,

  creator__email_address,

  creator__postal_code,

  reviewed_date,

  reviewed_by_id,

  reviewed_by__modified_date,

  reviewed_by__given_name,

  reviewed_by__family_name,

  reviewed_by__email_address,

  reviewed_by__phone_number,

  reviewed_by__postal_code,

  accessibility_notes,

  accessibility_status,

  is_virtual,

  virtual_action_url,

  event_campaign_id,

  event_campaign__slug as event_campaign

from {{ source( schema_name, 'events') }}


{%- endmacro %}
