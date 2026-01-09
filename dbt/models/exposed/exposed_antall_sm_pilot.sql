SELECT
    SUM(a.antall_sm) totalt_antall,
    a.aar
FROM {{ref('marts_antall_per_type')}} AS a
WHERE a.sm_type = 'DIGITAL'
GROUP BY aar
ORDER BY aar
   