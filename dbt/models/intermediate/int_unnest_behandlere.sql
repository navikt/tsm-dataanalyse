with base as (
    select
        id,
        behandler_ids,
        sykmelder_ids,
    from {{ ref('stg_regulus_maximus__sykmeldinger')}}
),

-- Flatten behandler JSON column
behandler_flat as (
    select
        id,
        JSON_VALUE(item, '$.id') as id_value,
        JSON_VALUE(item, '$.type') as id_type
    from base,
    unnest(behandler_ids) as item
),

-- Pivot behandler JSON column
behandler_pivot as (
    select
        id,
        max(case when id_type = 'HPR' then id_value end) as behandler_hpr,
        --max(case when id_type = 'FNR' then id_value end) as behandler_fnr
        --max(case when id_type = 'FNR' then id_value end) as behandler_?  #TODO: Finnes flere typer?
    from behandler_flat
    group by id
),

-- Flatten sykmelder JSON column
sykmelder_flat as (
    select
        id,
        JSON_VALUE(item, '$.id') as id_value,
        JSON_VALUE(item, '$.type') as id_type
    from base,
    unnest(sykmelder_ids) as item
),

-- Pivot sykmelder JSON column
sykmelder_pivot as (
    select
        id,
        max(case when id_type = 'HPR' then id_value end) as sykmelder_hpr,
        --max(case when id_type = 'FNR' then id_value end) as sykmelder_fnr
        --max(case when id_type = 'FNR' then id_value end) as  #TODO: Finnes flere ider?
    from sykmelder_flat
    group by id
)

-- Combine
select
    base.id as id,
    --b.behandler_fnr,
    b.behandler_hpr,
    --s.sykmelder_fnr,
    s.sykmelder_hpr
from base
left join behandler_pivot b using(id)
left join sykmelder_pivot s using(id)
