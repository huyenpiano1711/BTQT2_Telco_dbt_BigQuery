
with source as (
    select *
    from {{ source('bronze_telco', 'customers_raw') }}
),

renamed_and_casted as (
    select
        trim(customerID)                                    as customer_id,
        trim(gender)                                        as gender,
        cast(SeniorCitizen as int64)                        as senior_citizen,
        trim(Partner)                                       as partner,
        trim(Dependents)                                    as dependents,
        cast(tenure as int64)                               as tenure,
        trim(PhoneService)                                  as phone_service,
        trim(MultipleLines)                                 as multiple_lines,
        trim(InternetService)                               as internet_service,
        trim(OnlineSecurity)                                as online_security,
        trim(OnlineBackup)                                  as online_backup,
        trim(DeviceProtection)                              as device_protection,
        trim(TechSupport)                                   as tech_support,
        trim(StreamingTV)                                   as streaming_tv,
        trim(StreamingMovies)                               as streaming_movies,
        trim(Contract)                                      as contract,
        trim(PaperlessBilling)                              as paperless_billing,
        trim(PaymentMethod)                                 as payment_method,
        cast(MonthlyCharges as numeric)                     as monthly_charges,
        safe_cast(
            nullif(trim(TotalCharges), '') as numeric
        )                                                   as total_charges,
        trim(Churn)                                         as churn,
        _ingested_at,
        _source_file
    from source
)

select *
from renamed_and_casted
