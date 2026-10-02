-- Orgnummer kommer fra ulike felter avhengig av type. Feltene er hentet ut i stg-modellene per type.
with base as (
    select
        id,
        sm_type,
        sender_ids,
        orgnummer_digital,
        orgnummer_mottakenhetBlokk,
    from {{ ref('int_sykmeldinger_unioned')}}
),

-- Flatten sender JSON column (XML og PAPIR)
sender_flat as (
    select
        id,
        JSON_VALUE(item, '$.id') as id_value,
        JSON_VALUE(item, '$.type') as id_type
    from base
    cross join unnest(sender_ids) as item
),

-- Pivot sender JSON column
sender_pivot as (
    select
        id,
        max(case when id_type = 'ENH' then id_value end) as orgnummer_enh,
        array_agg(case when id_type = 'HER' then id_value end ignore nulls) as HER_id
    from sender_flat
    group by id
)

-- Combine
select
    base.id,
    base.sm_type,
    case
        when s.orgnummer_enh is not null and base.orgnummer_digital is not null then
            error('Found orgnummer in both enh and digital')
        when base.sm_type = 'PAPIR' then null
        when base.sm_type = 'DIGITAL' and base.orgnummer_digital is not null then base.orgnummer_digital
        when base.sm_type = 'XML' and s.orgnummer_enh is not null then s.orgnummer_enh
        else base.orgnummer_mottakenhetBlokk
        --TODO: add tests
    end as merged_orgnummer,
    s.HER_id,
from base
left join sender_pivot as s using (id)
