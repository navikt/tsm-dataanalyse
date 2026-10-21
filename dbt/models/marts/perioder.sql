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
    p.type periode_type,
    p.fom,
    p.tom,
    p.medisinsk_arsak_beskrivelse,
    p.medisinsk_arsak_arsak,
    p.arbeidsrelatert_arsak,
    p.arbeidsrelatert_arsak_beskrivelse,
    p.enkeltstaende_behandlingsdager,
    p.grad,
    p.gradert_reisetilskudd,
    p.avventene_innspill_til_arbeidsgiver,
FROM {{ ref('int_union_sykmeldinger') }} s
CROSS JOIN unnest(s.perioder) AS p -- cross join drops ids with an empty array
