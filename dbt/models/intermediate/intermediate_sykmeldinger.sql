SELECT
    sm.id,
    DATE(LEFT(sm.mottattDato, 10)) AS mottattDato,
    sm.sm_type,
FROM {{ref('staging_sykmeldinger')}} AS sm
