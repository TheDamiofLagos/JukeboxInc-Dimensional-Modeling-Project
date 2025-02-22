select *
from {{ ref("int__sales_payments") }}
where payment_order = 1
  and try_to_number(PaymentAmount) <= try_to_number(purchase_price)
  and payment_type != 'Installation Installment'