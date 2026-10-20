WITH
    sykmeldinger AS (

        SELECT

            *

        FROM {{ ref('stg__sykmeldinger') }}
    ),

    utenlandske_sykmeldinger AS (

        SELECT

            *

        FROM {{ ref('stg__utenlandske_sykmeldinger') }}
    ),

    final AS (

        SELECT

            *

        FROM sykmeldinger

        FULL UNION ALL BY NAME

        SELECT

            *

        FROM utenlandske_sykmeldinger
    )

select * from final
