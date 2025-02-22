select *
from {{ model }}
where payment_order > 1
  and payment_type != 'Royalty Payment'