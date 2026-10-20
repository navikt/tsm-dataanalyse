{{ config(alias='marts_sykmelding_new') }}   -- use marts_validation_new in marts_validation.sql

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
            avsenderSystem_integrasjon,
            avsenderSystem_versjon,
            regelsettVersjon,
            helsepersonellKategori,
            prognose_arbeid,
            arbeidsforEtterPeriode,
            tilbakedatering_kontaktDato,
            har_tilbakedatering_begrunnelse,
            generertDato,
            generated_timestamp,
            hoveddiagnose_system,
            metadata_type,
            friskmelding_til_arbeidsformidling,
            utenlandsk_land,
            annen_fravarsgrunn,
            har_hensyn_arbeidsplassen,
            har_utdypende_hensyn_arbeidsplassen,
            prognose_annet_arbeid_pa_sikt
        FROM {{ ref('int_sykmeldinger_unioned') }}
    ),

    sykmeldinger_derived AS (
        SELECT
            id,
            mottattDato,
            aar,
            mnd,
            dag,
            er_tilbakedatert
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
            LOGICAL_OR(aktivitetType = 'GRADERT' AND grad < 100) AS har_gradert_periode,
        FROM {{ ref('int_unnest_perioder') }}
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
            sm.avsenderSystem_integrasjon,
            sm.avsenderSystem_versjon,
            sm.regelsettVersjon,
            sm.helsepersonellKategori,
            sm.prognose_arbeid,
            sm.arbeidsforEtterPeriode,
            sm.tilbakedatering_kontaktDato,
            sm.har_tilbakedatering_begrunnelse,
            sm.generertDato,
            sm.generated_timestamp,
            sm.hoveddiagnose_system,
            sm.metadata_type,
            sm.friskmelding_til_arbeidsformidling,
            sm.utenlandsk_land,
            sm.annen_fravarsgrunn,
            sm.har_hensyn_arbeidsplassen,
            sm.har_utdypende_hensyn_arbeidsplassen,
            sm.prognose_annet_arbeid_pa_sikt,
            d.mottattDato,
            d.aar,
            d.mnd,
            d.dag,
            d.er_tilbakedatert,
            o.merged_orgnummer,
            o.HER_id,
            b.behandler_hpr,
            b.sykmelder_hpr,
            p.har_gradert_periode,
        FROM sykmeldinger AS sm
        LEFT JOIN sykmeldinger_derived AS d USING (id)
        LEFT JOIN org AS o USING (id)
        LEFT JOIN behandlere AS b USING (id)
        LEFT JOIN perioder AS p USING (id)
    )

SELECT * FROM final
