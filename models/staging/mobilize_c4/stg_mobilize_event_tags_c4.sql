select

  id as event_tag_id,

  {{ standarize_timezone('created_date') }} as event_tag_created_at,

  {{ standarize_timezone('modified_date') }} as event_tag_modified_at,

  {{ standarize_timezone('deleted_date') }} as event_tag_deleted_at,

  event_id


from {{ source('sunrise_mobilize', 'event_tags')}}
