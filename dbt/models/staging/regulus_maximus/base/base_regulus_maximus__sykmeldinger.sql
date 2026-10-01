{{ config(materialized='ephemeral') }}

{#
    Eneste modell som leser fra kilden. Henter kun felter som er felles for alle
    sykmeldingstyper. Typespesifikke felter hentes ut i stg_regulus_maximus__sykmeldinger_<type>.

    Ephemeral: modellen legges inn som CTE i stg-modellene.
#}

with

src as (

  SELECT
    sykmelding_id,
    fom,
    tom,
    sykmelding,
    metadata,
    JSON_VALUE(validation, '$.status') AS last_status,
    JSON_QUERY_ARRAY(sykmelding, '$.aktivitet') AS aktivitet,
    JSON_QUERY_ARRAY(validation, '$.rules') as rules_array,
    JSON_VALUE(metadata, '$.type') AS metadata_type,
    {{ extract_json_fields(
      'sykmelding', [
        {'key': 'type', 'name': 'sm_type'},
        {'key':'metadata.mottattDato', 'name': 'mottattDato' },
        {'key':'metadata.avsenderSystem.navn', 'name': 'avsenderSystem_navn' },
        {'key':'metadata.avsenderSystem.versjon', 'name': 'avsenderSystem_versjon' },
        {'key':'medisinskVurdering.hovedDiagnose.system', 'name': 'hoveddiagnose_system' }
        ]
      )
    }},
    generated_date,

  FROM {{ source('tsm_dataset', 'regulus_maximus') }}

),

final as (

  SELECT
    sykmelding_id as id,
    fom,
    tom,
    sm_type,
    metadata_type,
    last_status,
    aktivitet,
    rules_array,
    DATE(LEFT(mottattDato, 10)) mottattDato,
    format_timestamp('%Y-%m-%d %H:%M:%S UTC', generated_date, 'UTC') generated_timestamp,
    DATE(generated_date) generertDato,
    avsenderSystem_navn,
    avsenderSystem_versjon,
    hoveddiagnose_system,
    sykmelding,
    metadata,

    FROM src

)

SELECT * FROM final
