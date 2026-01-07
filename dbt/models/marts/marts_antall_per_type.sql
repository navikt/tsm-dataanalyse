SELECT
    COUNT(DISTINCT sm.id) AS antall_sm,
    sm.sm_type,
    EXTRACT(YEAR from sm.mottattDato) AS aar
FROM {{ref('intermediate_sykmeldinger')}} AS sm
GROUP BY sm_type, aar
ORDER BY aar
