WITH
    base AS (
        SELECT
          id,
          aktivitet
        FROM
            {{ ref('stg_regulus_maximus__sykmeldinger')}}
    ),

    aktivitet_flat AS (
        SELECT
          id,
          DATE(JSON_VALUE(a, '$.fom')) AS fom,
          DATE(JSON_VALUE(a, '$.tom')) AS tom,
          JSON_VALUE(a, '$.type') AS aktivitetType,
          JSON_QUERY_ARRAY(a, '$.medisinskArsak.arsak') AS medisinskArsak_arsak,
          JSON_VALUE(a, '$.medisinskArsak.beskrivelse') AS medisinskArsak_beskrivelse,
          JSON_QUERY_ARRAY(a, '$.arbeidsrelatertArsak.arsak') AS arbeidsrelatertArsak_arsak,
          JSON_VALUE(a, '$.arbeidsrelatertArsak.beskrivelse') AS arbeidsrelatertArsak_beskrivelse,
        FROM base
        CROSS JOIN UNNEST(aktivitet) AS a
    )

SELECT * FROM aktivitet_flat
