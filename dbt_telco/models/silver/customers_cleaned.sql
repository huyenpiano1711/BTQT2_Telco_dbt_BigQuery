with staging as (
    select *
    from {{ ref('stg_telco_customers') }}
),

normalized as (
    select
        customer_id,
        gender,
        case
            when senior_citizen = 1 then true
            when senior_citizen = 0 then false
            else null
        end as senior_citizen,
        case
            when partner = 'Yes' then true
            when partner = 'No' then false
            else null
        end as partner,
        case
            when dependents = 'Yes' then true
            when dependents = 'No' then false
            else null
        end as dependents,
        tenure,
        case
            when phone_service = 'Yes' then true
            when phone_service = 'No' then false
            else null
        end as phone_service,
        case
            when multiple_lines = 'No phone service' then 'No'
            else multiple_lines
        end as multiple_lines,
        internet_service,
        case
            when online_security = 'No internet service' then 'No'
            else online_security
        end as online_security,
        case
            when online_backup = 'No internet service' then 'No'
            else online_backup
        end as online_backup,
        case
            when device_protection = 'No internet service' then 'No'
            else device_protection
        end as device_protection,
        case
            when tech_support = 'No internet service' then 'No'
            else tech_support
        end as tech_support,
        case
            when streaming_tv = 'No internet service' then 'No'
            else streaming_tv
        end as streaming_tv,
        case
            when streaming_movies = 'No internet service' then 'No'
            else streaming_movies
        end as streaming_movies,
        contract,
        case
            when paperless_billing = 'Yes' then true
            when paperless_billing = 'No' then false
            else null
        end as paperless_billing,
        payment_method,
        monthly_charges,
        total_charges,
        case
            when churn = 'Yes' then true
            when churn = 'No' then false
            else null
        end as churn,
        _ingested_at,
        _source_file
    from staging
),

imputed as (
    select
        *,
        tenure = 0 as is_new_customer,
        tenure = 0 and total_charges is null as is_total_charges_imputed,
        case
            when tenure = 0 and total_charges is null then cast(0 as numeric)
            else total_charges
        end as total_charges_cleaned
    from normalized
)

select
    customer_id,
    gender,
    senior_citizen,
    partner,
    dependents,
    tenure,
    phone_service,
    multiple_lines,
    internet_service,
    online_security,
    online_backup,
    device_protection,
    tech_support,
    streaming_tv,
    streaming_movies,
    contract,
    paperless_billing,
    payment_method,
    monthly_charges,
    total_charges_cleaned as total_charges,
    churn,
    is_new_customer,
    is_total_charges_imputed,
    coalesce(
        safe_divide(
            abs(total_charges_cleaned - tenure * monthly_charges),
            tenure * monthly_charges
        ) > 0.2,
        false
    ) as is_charge_variance,
    _ingested_at,
    _source_file
from imputed
