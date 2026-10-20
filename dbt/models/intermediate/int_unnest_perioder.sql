WITH
    base AS (
        SELECT
          id,
          aktivitet
        FROM
            {{ ref('int_sykmeldinger_unioned')}}
    ),

    aktivitet_flat AS (
        SELECT
          id,
          DATE(JSON_VALUE(a, '$.fom')) AS fom,
          DATE(JSON_VALUE(a, '$.tom')) AS tom,
          JSON_VALUE(a, '$.type') AS aktivitetType,

          CAST(JSON_VALUE(a, '$.grad') AS INT64) AS grad,
          --JSON_VALUE_ARRAY(a, '$.medisinskArsak.arsak') AS medisinskArsak_arsak,
          NULLIF(TRIM(JSON_VALUE(a, '$.medisinskArsak.beskrivelse')), '') IS NOT NULL AS har_medisinskArsak_beskrivelse,
          --JSON_VALUE_ARRAY(a, '$.arbeidsrelatertArsak.arsak') AS arbeidsrelatertArsak_arsak,
          NULLIF(TRIM(JSON_VALUE(a, '$.arbeidsrelatertArsak.beskrivelse')), '') IS NOT NULL AS har_arbeidsrelatertArsak_beskrivelse,
        FROM base
        CROSS JOIN UNNEST(aktivitet) AS a
    )

SELECT * FROM aktivitet_flat
