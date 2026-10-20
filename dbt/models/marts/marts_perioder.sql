select
  -- key + clustering + partition is always included
  s.id,
  s.generert_dato,
  s.type,
  s.avsender_system,
  s.regelutfall,
  s.regelutfall_timestamp,
  s.avsendersystem_navn,
  s.avsenderSystem_integrasjon,
  -- Unnest repeated records
  p.type periode_type,
  p.fom,
  p.tom,
  p.medisinsk_arsak_beskrivelse,
  p.medisinsk_arsak_arsak,
  p.arbeidsrelatert_arsak,
  p.arbeidsrelatert_arsak_beskrivelse,
  p.enkeltstaende_behandlingsdager,
  p.grad,
  p.gradert_reisetilskudd,
  p.avventene_innspill_til_arbeidsgiver,
from {{ ref('int_union_sykmeldinger') }} s
cross join unnest(s.perioder) as p -- cross join drops ids with an empty array
