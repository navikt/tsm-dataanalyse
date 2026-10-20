WITH
    sykmeldinger AS (

        SELECT

            * except(perioder, regelutfall_historikk)

        FROM {{ ref('int_union_sykmeldinger') }}
    ),

    final AS (

        SELECT

            *,
            extract(YEAR FROM generert_dato)  as aar,
            extract(MONTH from generert_dato) as mnd,
            extract(DAY from generert_dato) as dag,

        FROM sykmeldinger

    )


SELECT * FROM final
