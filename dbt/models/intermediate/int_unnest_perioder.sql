WITH
    aktivitet_flat AS (
        SELECT
          id,
          date(json_value(a, '$.fom')) AS fom,
          date(json_value(a, '$.tom')) AS tom,
          json_value(a, '$.type') AS aktivitetType,
          JSON_QUERY_ARRAY(a, '$.medisinskArsak.arsak') AS medisinskArsak_arsak,
          json_value(a, '$.medisinskArsak.beskrivelse') AS medisinskArsak_beskrivelse,
          JSON_QUERY_ARRAY(a, '$.arbeidsrelatertArsak.arsak') AS arbeidsrelatertArsak_arsak,
          json_value(a, '$.arbeidsrelatertArsak.beskrivelse') AS arbeidsrelatertArsak_beskrivelse,
        FROM
            {{ ref('stg_regulus_maximus__sykmeldinger')}}
        CROSS JOIN UNNEST(aktivitet) AS a
    ),
    periods as(
        SELECT
          *
        FROM aktivitet_flat
    )

SELECT * from periods
