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
  p.type regelutfall_type,
  p.timestamp,
  p.status,
  p.reason_sykmelder,
  p.reason_sykmeldt,
from {{ ref('int_union_sykmeldinger') }} s
cross join unnest(s.regelutfall_historikk) as p -- cross join drops ids with an empty array
