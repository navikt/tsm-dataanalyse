{#
    Digitale sykmeldinger (syk-inn). Strukturen her forventes å endre seg mye,
    så nye DIGITAL-felter legges til kun i denne modellen.
#}

with

sykmeldinger as (

  SELECT *
  FROM {{ ref('base_regulus_maximus__sykmeldinger') }}
  WHERE sm_type = 'DIGITAL'

),

final as (

  SELECT
    * EXCEPT (sykmelding, metadata),

    -- metadata
    JSON_VALUE(metadata, '$.orgnummer') AS orgnummer_digital,

    -- felles for nasjonale sykmeldinger
    JSON_VALUE(sykmelding, '$.sykmelder.helsepersonellKategori') AS helsepersonellKategori,
    DATE(JSON_VALUE(sykmelding, '$.tilbakedatering.kontaktDato')) AS tilbakedatering_kontaktDato,
    JSON_QUERY_ARRAY(sykmelding, '$.behandler.ids') AS behandler_ids,
    JSON_QUERY_ARRAY(sykmelding, '$.sykmelder.ids') AS sykmelder_ids,

    -- kun DIGITAL
    CAST(JSON_VALUE(sykmelding, '$.prognose.friskmeldingTilArbeidsformidling') AS BOOL) AS friskmelding_til_arbeidsformidling,

    -- annenFravarsgrunn er én verdi her, men en liste i XML, papir og utenlandsk (annenFraversArsak.arsak)
    IF(
      JSON_VALUE(sykmelding, '$.medisinskVurdering.annenFravarsgrunn') IS NULL,
      NULL,
      [JSON_VALUE(sykmelding, '$.medisinskVurdering.annenFravarsgrunn')]
    ) AS annen_fravarsgrunn,

    -- utdypende 6.3.3 svar
    EXISTS (
      SELECT 1
      FROM UNNEST(JSON_QUERY_ARRAY(sykmelding, '$.utdypendeSporsmal')) AS u
      WHERE JSON_VALUE(u, '$.type') = 'HENSYN_PA_ARBEIDSPLASSEN'
        AND NULLIF(TRIM(JSON_VALUE(u, '$.svar')), '') IS NOT NULL
    ) AS utdypende_hensyn_arbeidsplassen,

  FROM sykmeldinger

)

SELECT * FROM final
