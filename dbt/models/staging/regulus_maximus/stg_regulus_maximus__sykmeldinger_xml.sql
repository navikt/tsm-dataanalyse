with

sykmeldinger as (

  SELECT *
  FROM {{ ref('base_regulus_maximus__sykmeldinger') }}
  WHERE sm_type = 'XML'

),

final as (

  SELECT
    * EXCEPT (sykmelding, metadata),

    -- metadata
    JSON_VALUE(metadata, '$.mottakenhetBlokk.avsender') AS orgnummer_mottakenhetBlokk,
    JSON_QUERY_ARRAY(metadata, '$.sender.ids') AS sender_ids,

    -- XML, PAPIR og DIGITAL
    JSON_VALUE(sykmelding, '$.sykmelder.helsepersonellKategori') AS helsepersonellKategori,
    DATE(JSON_VALUE(sykmelding, '$.tilbakedatering.kontaktDato')) AS tilbakedatering_kontaktDato,
    --JSON_VALUE(sykmelding, '$.tilbakedatering.begrunnelse') AS tilbakedatering_begrunnelse,
    JSON_QUERY_ARRAY(sykmelding, '$.behandler.ids') AS behandler_ids,
    JSON_QUERY_ARRAY(sykmelding, '$.sykmelder.ids') AS sykmelder_ids,

    -- felles for XML, PAPIR, UTENLANDSK
    JSON_VALUE(sykmelding, '$.metadata.regelsettVersjon') AS regelsettVersjon,
    JSON_VALUE_ARRAY(sykmelding, '$.medisinskVurdering.annenFraversArsak.arsak') AS annen_fravarsgrunn,

    -- felles for XML, PAPIR
    JSON_VALUE(sykmelding, '$.prognose.arbeid.type') AS prognose_arbeid,
    -- kun om fritekst er oppgitt, ikke selve teksten
    NULLIF(TRIM(JSON_VALUE(sykmelding, '$.prognose.hensynArbeidsplassen')), '') IS NOT NULL AS hensyn_arbeidsplassen,
    JSON_VALUE(sykmelding, '$.prognose.arbeidsforEtterPeriode') AS arbeidsforEtterPeriode,
    CAST(JSON_VALUE(sykmelding, '$.prognose.arbeid.annetArbeidPaSikt') AS BOOL) AS prognose_annet_arbeid_pa_sikt,
    -- tilsvarer DIGITAL utdypendeSporsmal HENSYN_PA_ARBEIDSPLASSEN
    NULLIF(TRIM(JSON_VALUE(sykmelding, '$.utdypendeOpplysninger."6.3"."6.3.3".svar')), '') IS NOT NULL AS utdypende_hensyn_arbeidsplassen,

  FROM sykmeldinger

)

SELECT * FROM final
