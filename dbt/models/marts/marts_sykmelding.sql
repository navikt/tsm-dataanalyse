WITH
    sykmeldinger AS (
        SELECT
            id,
            fom,
            tom,
            pasient_ident,
            sm_type,
            last_status,
            avsenderSystem_navn,
            avsenderSystem_versjon,
            regelsettVersjon,
            helsepersonellKategori,
            prognose_arbeid,
            prognose_hensynArbeidsplassen,
            arbeidsforEtterPeriode,
            tilbakedatering_kontaktDato,
            tilbakedatering_begrunnelse,
            generertDato,
            generated_timestamp
        FROM {{ ref('stg_regulus_maximus__sykmeldinger') }}
    ),

    sykmeldinger_derived AS (
        SELECT
            id,
            mottattDato,
            aar,
            mnd,
            dag,
            tilbakedatert_sykmelding
        FROM {{ ref('int_sykmeldinger') }}
    ),

    org AS (
        SELECT
            id,
            merged_orgnummer,
            HER_id
        FROM {{ ref('int_org') }}
    ),

    behandlere AS (
        SELECT
            id,
            behandler_hpr,
            sykmelder_hpr
        FROM {{ ref('int_unnest_behandlere') }}
    ),

    perioder AS (
        SELECT
            id,
            ARRAY_AGG(
                STRUCT(
                    fom,
                    tom,
                    aktivitetType,
                    medisinskArsak_arsak,
                    medisinskArsak_beskrivelse,
                    arbeidsrelatertArsak_arsak,
                    arbeidsrelatertArsak_beskrivelse
                )
                ORDER BY fom, tom
            ) AS perioder
        FROM {{ ref('int_unnest_perioder') }}
        GROUP BY id
    ),

    validering AS (
        SELECT
            id,
            ARRAY_AGG(
                STRUCT(
                    rule_name,
                    rule_type,
                    reason_sykmelder,
                    reason_sykmeldt,
                    rule_timestamp,
                    validationType
                )
                ORDER BY rule_timestamp
            ) AS validering
        FROM {{ ref('int_unnest_validation') }}
        GROUP BY id
    ),

    final AS (
        SELECT
            sm.id,
            sm.fom,
            sm.tom,
            sm.pasient_ident,
            sm.sm_type,
            sm.last_status,
            sm.avsenderSystem_navn,
            sm.avsenderSystem_versjon,
            sm.regelsettVersjon,
            sm.helsepersonellKategori,
            sm.prognose_arbeid,
            sm.prognose_hensynArbeidsplassen,
            sm.arbeidsforEtterPeriode,
            sm.tilbakedatering_kontaktDato,
            sm.tilbakedatering_begrunnelse,
            sm.generertDato,
            sm.generated_timestamp,
            d.mottattDato,
            d.aar,
            d.mnd,
            d.dag,
            d.tilbakedatert_sykmelding,
            o.merged_orgnummer,
            o.HER_id,
            b.behandler_hpr,
            b.sykmelder_hpr,
            p.perioder,
            v.validering
        FROM sykmeldinger AS sm
        LEFT JOIN sykmeldinger_derived AS d USING (id)
        LEFT JOIN org AS o USING (id)
        LEFT JOIN behandlere AS b USING (id)
        LEFT JOIN perioder AS p USING (id)
        LEFT JOIN validering AS v USING (id)
    )

SELECT * FROM final
