{{ config(materialized='table') }}

SELECT

    generated_timestamp,
    orgnummer,
    avsenderSystem_navn epjsystem,

FROM {{ ref('sykmeldinger') }}

WHERE generated_timestamp >= '2026-01-01' AND generated_timestamp <= '2026-03-01'

ORDER BY generated_timestamp, orgnummer, avsenderSystem_navn
