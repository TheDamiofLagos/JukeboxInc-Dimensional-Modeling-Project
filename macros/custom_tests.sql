{% macro test_payment_type_valid_sale(model, column_name) %}
  select *
  from {{ model }}
  where payment_order = 1
    and cast(PaymentAmount as numeric) > cast(purchase_price as numeric)
    and {{ column_name }} != 'Valid Sale'
{% endmacro %}

{% macro test_payment_type_installment(model, column_name) %}
  select *
  from {{ model }}
  where payment_order = 1
    and cast(PaymentAmount as numeric) <= cast(purchase_price as numeric)
    and {{ column_name }} != 'Installation Installment'
{% endmacro %}

{% macro test_payment_type_royalty(model, column_name) %}
  select *
  from {{ model }}
  where payment_order > 1
    and {{ column_name }} != 'Royalty Payment'
{% endmacro %}
