with

src as (

  SELECT
  *
  FROM {{ source('tsm_kafka_sink', 'sykmeldinger_utenlandsk') }}

)

SELECT
  * except(kafka_partition, kafka_offset, kafka_epoch, meta_generert_dato, meta_nav_mottatt_dato, meta_avsender_system, meta_avsender_version),
  meta_generert_dato generert_dato,
  meta_nav_mottatt_dato mottatt_dato,
  meta_avsender_system avsender_system,
  meta_avsender_version avsender_versjon,
  meta_avsender_system as avsenderSystem_integrasjon
FROM src
qualify row_number() OVER (
  partition by id, meta_generert_dato, type, meta_avsender_system
  order by regelutfall_timestamp desc, kafka_offset desc
) = 1
