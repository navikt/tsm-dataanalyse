{#jinja comments#}

WITH sykmeldinger as (

    SELECT *
    from {{ ref('int_sykmeldinger_unioned') }}

),

some_transformation AS (

    SELECT
        id,
        mottattDato,
        EXTRACT( YEAR FROM mottattDato ) aar,
        EXTRACT( MONTH FROM mottattDato ) mnd,
        EXTRACT( DAY FROM mottattDato ) dag,
        CASE
            WHEN tilbakedatering_kontaktDato is not null THEN TRUE
            ELSE FALSE
        END AS tilbakedatert_sykmelding

    from sykmeldinger
)

SELECT * FROM some_transformation
