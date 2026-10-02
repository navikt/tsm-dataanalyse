{#
    Slår sammen sykmeldingstypene til én rad per sykmelding.
    FULL UNION ALL BY NAME matcher kolonner på navn og fyller inn NULL for
    felter som ikke finnes på en type.
#}

SELECT * FROM {{ ref('stg_regulus_maximus__sykmeldinger_digital') }}
FULL UNION ALL BY NAME
SELECT * FROM {{ ref('stg_regulus_maximus__sykmeldinger_xml') }}
FULL UNION ALL BY NAME
SELECT * FROM {{ ref('stg_regulus_maximus__sykmeldinger_papir') }}
FULL UNION ALL BY NAME
SELECT * FROM {{ ref('stg_regulus_maximus__sykmeldinger_utenlandsk') }}
