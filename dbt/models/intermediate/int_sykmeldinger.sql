
WITH sykmeldinger as (

    SELECT *
    from {{ ref('int_sykmeldinger_unioned') }}

),

final AS (

    SELECT
        id,
        mottattDato,
        EXTRACT( YEAR FROM mottattDato ) aar,
        EXTRACT( MONTH FROM mottattDato ) mnd,
        EXTRACT( DAY FROM mottattDato ) dag,
        CASE
            WHEN tilbakedatering_kontaktDato is not null THEN TRUE
            ELSE FALSE
        END AS er_tilbakedatert

    from sykmeldinger
)

SELECT * FROM final
