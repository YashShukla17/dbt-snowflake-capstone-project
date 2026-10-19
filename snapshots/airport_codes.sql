{% snapshot airport_codes %}

{{
   config(
       unique_key='id',
       strategy='check',
       check_cols = ['airport_code'],
       invalidate_hard_deletes =True
   )
}}

select 
{{ dbt_utils.generate_surrogate_key(['airport_code','city']) }} as id
,airport_code,city,country from {{ ref('stg_airports') }}

{% endsnapshot %}