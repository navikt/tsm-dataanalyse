WITH
    val AS (
        SELECT
            id,
            last_status,
            rule_name,
            rule_type,
            reason_sykmelder,
            reason_sykmeldt,
            rule_timestamp,
            validationType
        FROM {{ ref('int_unnest_validation') }}
    ),

    sm_context AS (
        SELECT
            id,
            mottattDato,
            aar
        FROM {{ ref('int_sykmeldinger') }}
    ),

    sm_type AS (
        SELECT
            id,
            sm_type
        FROM {{ ref('stg_regulus_maximus__sykmeldinger') }}
    ),

    final AS (
        SELECT
            v.id,
            v.rule_name,
            v.rule_type,
            v.reason_sykmelder,
            v.reason_sykmeldt,
            v.rule_timestamp,
            v.validationType,
            v.last_status,
            t.sm_type,
            c.mottattDato,
            c.aar
        FROM val AS v
        LEFT JOIN sm_context AS c USING (id)
        LEFT JOIN sm_type AS t USING (id)
    )

SELECT * FROM final
