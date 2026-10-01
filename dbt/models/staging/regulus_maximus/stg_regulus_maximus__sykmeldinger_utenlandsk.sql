with

sykmeldinger as (

  SELECT *
  FROM {{ ref('base_regulus_maximus__sykmeldinger') }}
  WHERE sm_type = 'UTENLANDSK'

),

final as (

  SELECT
    * EXCEPT (sykmelding, metadata),

    -- felles for XML, PAPIR, UTENLANDSK
    JSON_VALUE_ARRAY(sykmelding, '$.medisinskVurdering.annenFraversArsak.arsak') AS annen_fravarsgrunn,

    -- kun UTENLANDSK
    JSON_VALUE(sykmelding, '$.utenlandskInfo.land') AS utenlandsk_land,
    CAST(JSON_VALUE(sykmelding, '$.utenlandskInfo.erAdresseUtland') AS BOOL) AS er_adresse_utland,

  FROM sykmeldinger

)

SELECT * FROM final
