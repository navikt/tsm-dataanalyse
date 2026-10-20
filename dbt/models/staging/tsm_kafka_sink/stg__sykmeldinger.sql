with

src as (

  SELECT
  *
  FROM {{ source('tsm_kafka_sink', 'sykmeldinger') }}

)

SELECT
  * except (kafka_partition, kafka_offset, kafka_epoch, meta_generert_dato, meta_nav_mottatt_dato, meta_avsender_system, meta_avsender_version, meta_regelsett_versjon, meta_orgnummer),
  meta_generert_dato generert_dato,
  meta_nav_mottatt_dato mottatt_dato,
  meta_avsender_system avsender_system,
  meta_avsender_version avsender_versjon,
  meta_regelsett_versjon regelsett_versjon,
  meta_orgnummer orgnummer,
  CASE
    WHEN meta_avsender_system IS NULL OR meta_avsender_system = 'papir' then NULL
    ELSE TRIM(regexp_replace(meta_avsender_system, r'\s*\([^)]*\)\s*$', ''))
  END AS avsender_system_navn,
  CASE
    WHEN meta_avsender_system IS NULL OR meta_avsender_system = 'papir' then NULL
    ELSE coalesce(regexp_extract(meta_avsender_system, r'\(([^)]*)\)\s*$'), 'XML')
  END AS avsender_system_integrasjon
FROM src
qualify row_number() OVER (
  partition by id, meta_generert_dato, type, meta_avsender_system
  order by regelutfall_timestamp desc, kafka_offset desc
) = 1
