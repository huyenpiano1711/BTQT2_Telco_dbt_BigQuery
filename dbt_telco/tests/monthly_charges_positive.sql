select
    customer_id,
    monthly_charges
from {{ ref('customers_cleaned') }}
where monthly_charges <= 0
