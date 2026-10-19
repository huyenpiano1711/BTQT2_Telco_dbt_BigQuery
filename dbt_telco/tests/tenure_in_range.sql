select
    customer_id,
    tenure
from {{ ref('customers_cleaned') }}
where tenure < 0
   or tenure > 72
