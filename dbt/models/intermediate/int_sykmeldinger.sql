{#jinja comments#}

WITH sykmeldinger as (

    SELECT *
    from {{ ref('stg_regulus_maximus__sykmeldinger') }}

),

some_transformation AS (

    SELECT
        id,
        mottattDato,
        EXTRACT( YEAR FROM mottattDato ) aar,
        EXTRACT( MONTH FROM mottattDato ) mnd,
        EXTRACT( DAY FROM mottattDato ) dag,
        generated_timestamp,
        sm_type,
        avsenderSystem_navn,
        helsepersonellKategori,
        CASE
            WHEN tilbakedatering_kontaktDato is not null THEN TRUE
            ELSE FALSE
        END AS tilbakedatert_sykmelding
        tilbakedatering_kontaktDato,
        tilbakedatering_begrunnelse,

    from sykmeldinger
)

SELECT * FROM some_transformation
