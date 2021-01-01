select

  id as sms_opt_in_id,

  {{ standarize_timezone('created_date') }} as sms_opt_in_created_at,

  {{ standarize_timezone('modified_date') }} as sms_opt_in_modified_at,

  sms_opt_in_status,

  user_id,

  user__phone_number as phone,

  organization_id

from {{ source('sunrise_mobilize', 'sms_opt_ins') }}
