{{ config(severity='warn') }}

select
    customer_id,
    tenure,
    monthly_charges,
    total_charges,
    is_charge_variance
from {{ ref('customers_cleaned') }}
where is_charge_variance
