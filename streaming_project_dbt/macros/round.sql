{% macro round(value,precision) %}
    round({{ value }}, {{ precision }})
  
{% endmacro %}