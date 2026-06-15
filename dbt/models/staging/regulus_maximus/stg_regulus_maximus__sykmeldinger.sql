with

src as (

  SELECT
    sykmelding_id,
    fom,
    tom,
    pasient_ident,
    JSON_VALUE(validation, '$.status') AS last_status,
    JSON_QUERY_ARRAY(sykmelding, '$.aktivitet') AS aktivitet,
    JSON_QUERY_ARRAY(validation, '$.rules') as rules_array,
    {{ extract_json_fields(
      'sykmelding', [
        {'key': 'type', 'name': 'sm_type'},
        {'key':'prognose.arbeid', 'name': 'prognose_arbeid' },
        {'key':'prognose.hensynArbeidsplassen', 'name': 'prognose_hensynArbeidsplassen' },
        {'key':'prognose.arbeidsforEtterPeriode', 'name': 'arbeidsforEtterPeriode' },
        {'key':'metadata.mottattDato', 'name': 'mottattDato' },
        {'key':'metadata.avsenderSystem.navn', 'name': 'avsenderSystem_navn' },
        {'key':'metadata.avsenderSystem.versjon', 'name': 'avsenderSystem_versjon' },
        {'key':'metadata.regelsettVersjon', 'name': 'regelsettVersjon' },
        {'key':'metadata.behandletTidspunkt', 'name': 'behandletTidspunkt' },
        {'key':'sykmelder.helsepersonellKategori', 'name': 'helsepersonellKategori' },
        {'key':'arbeidsgiver.navn', 'name': 'arbeidsgiver_navn' },
        {'key':'arbeidsgiver.type', 'name': 'arbeidsgiver_type' },
        {'key':'medisinskVurdering.hovedDiagnose.system', 'name': 'hoveddiagnose_system' },
        {'key':'medisinskVurdering.syketilfelletStartDato', 'name': 'syketilfelletStartDato' }
        ]
      )
    }},
    JSON_VALUE(sykmelding, '$.tilbakedatering.kontaktDato') tilbakedatering_kontaktDato,
    JSON_VALUE(sykmelding, '$.tilbakedatering.begrunnelse') tilbakedatering_begrunnelse,
    JSON_VALUE(metadata, '$.mottakenhetBlokk.avsender') orgnummer_mottakenhetBlokk,
    JSON_VALUE(metadata, '$.orgnummer') orgnummer_digital,
    JSON_QUERY_ARRAY(metadata, '$.sender.ids') as sender_ids,
    JSON_QUERY_ARRAY(sykmelding, '$.behandler.ids') as behandler_ids,
    JSON_QUERY_ARRAY(sykmelding, '$.sykmelder.ids') as sykmelder_ids,
    JSON_QUERY(sykmelding, '$.utdypendeOpplysninger') as utdypendeOpplysninger,
    generated_date,

  FROM {{ source('tsm_dataset', 'regulus_maximus') }}

),

final as (

  SELECT
    sykmelding_id as id,
    fom,
    tom,
    pasient_ident,
    last_status,
    aktivitet,
    rules_array,
    sm_type,
    prognose_arbeid,
    prognose_hensynArbeidsplassen,
    arbeidsforEtterPeriode,
    DATE(LEFT(mottattDato, 10)) mottattDato,
    format_timestamp('%Y-%m-%d %H:%M:%S UTC', generated_date, 'UTC') generated_timestamp,
    DATE(generated_date) generertDato,
    avsenderSystem_navn,
    regelsettVersjon,
    helsepersonellKategori,
    DATE(tilbakedatering_kontaktDato) tilbakedatering_kontaktDato,
    tilbakedatering_begrunnelse,
    orgnummer_mottakenhetBlokk,
    orgnummer_digital,
    sender_ids,
    behandler_ids,
    sykmelder_ids,

    FROM src

)

SELECT * FROM final
