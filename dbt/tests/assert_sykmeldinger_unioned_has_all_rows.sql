-- Feiler hvis rader forsvinner mellom base og union, f.eks. ved en ny sykmeldingstype
-- som ikke har en egen stg-modell.
with

base as (
    select count(*) as antall from {{ ref('base_regulus_maximus__sykmeldinger') }}
),

unioned as (
    select count(*) as antall from {{ ref('int_sykmeldinger_unioned') }}
)

select
    base.antall as antall_base,
    unioned.antall as antall_unioned
from base
cross join unioned
where base.antall != unioned.antall
