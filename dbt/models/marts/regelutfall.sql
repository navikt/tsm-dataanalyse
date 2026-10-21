SELECT
    -- key + clustering + partition is always included
    s.id,
    s.generert_dato,
    s.type,
    s.avsender_system,
    s.regelutfall,
    s.regelutfall_timestamp,
    s.avsender_system_navn,
    s.avsender_system_integrasjon,
    -- Unnest repeated records
    p.type regelutfall_type,
    p.timestamp,
    p.status,
    p.reason_sykmelder,
    p.reason_sykmeldt,
FROM {{ ref('int_union_sykmeldinger') }} s
CROSS JOIN unnest(s.regelutfall_historikk) AS p -- cross join drops ids with an empty ar
