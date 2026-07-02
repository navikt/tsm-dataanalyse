WITH
  base AS(
  SELECT
    id,
    last_status,
    rules_array
  FROM
    {{ ref('stg_regulus_maximus__sykmeldinger')}}),

  flattened AS (
  SELECT
    id,
    last_status,
    JSON_VALUE(rule, '$.name') AS rule_name,
    JSON_VALUE(rule, '$.type') AS rule_type,
    JSON_VALUE(rule, '$.reason.sykmelder') AS reason_sykmelder,
    JSON_VALUE(rule, '$.reason.sykmeldt') AS reason_sykmeldt,
    JSON_VALUE(rule, '$.timestamp') AS rule_timestamp,
    JSON_VALUE(rule, '$.validationType') AS validationType,
  FROM
    base,
    UNNEST(rules_array) AS rule)
SELECT
  *
FROM
  flattened
ORDER BY id
