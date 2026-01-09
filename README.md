# TSM-datanalyse
DBT-prosjekt for Team-symfoni.

---
uv brukes for prosjektstyring og håndtering av avhengigheter.
just brukes for å kjøre kommandoer som ofte gjentas

Installer just med 'brew install just'. Just er en task/command runner, et verktøy som blir brukt for å definere og kjøre kommandoer. Kjør 'just --list' for å sjekke komandoene.

For å autentisere mot BigQuery og GCP kan du kjøre just login. For linting og pre-commit kan du kjøre just lint. Kommandoene ligger definert i justfile.

Vi bruker pre-commit for å kjøre sjekker på koden når man kjører git commit. Install pre-commit hvis du ikke har det med 'uv pip install pre-commit' + 'pre-commit install' for å legge til i hooks. Ved å bruke pre-commit skjer denne sjekken før koden blir lagret til git. Man kan også manuelt kjøre pre-commit ved å kjøre 'just lint' hvis man bruker just.
pre-commit er konfigurert i .pre-commit-config.yml.

## DBT
dbt prosjeketer må intialiseres første gang de skal kjøres, dette gjøres med kommandoen 'dbt init'.

dbt (data build tool) lar deg definere SQL-transformasjoner som modeller, versjonskontrollere dem, og kjøre dem deterministisk mot et datavarehus (BigQuery). dbt håndterer avhengigheter, materialisering (view/table), testing, dokumentasjon og miljøer

### Vanlige dbt kommandoer

'dbt debug' - Sjekker tilkobling mot BigQuery og om dbt er riktig satt opp.
'dbt run' - Kjører alle modeller. Target avhenger av profiles.yml
    'dbt run --select staging' - For å kjøre spesiefikke lag eller modell.
'dbt test' - Kjører alle tester.
'dbt compile' - Kompilerer alle modeller.
'dbt docs generate' - Genererer dokumentasjon for modellene.
'dbt docs serve' - Starter en lokal doc-server.
'dbt build' - Bygge alt i riktig rekkefølge

## Modeller
### Overordnet prosjektstruktur

```
.
├─ dbt/
│  └─  macros/                          # Gjenbrukbare funksjoner / Jinja
│  └─  models/
│      ├─ staging/                      # Rensing og standardisering av råtabeller (en-til-en)
│      ├─ intermediate/                 # Joiner, aggregerer og beriker (fler-til-en)
│      ├─ marts/                        # Forretningslag (dim/ fact / datasett til rapporter)
│      ├─ exposed/                      # Tabeller som eksponeres på datamarkedsplassen
│      └─ exposed_access_controlled/    # Eksponert på datamarkedsplassen, men tilgangsstyrt
│  └─ dbt_project.yml                   # Prosjektkonfig
│  └─ profiles.yml                      # Definerer BigQuery-tilkobling
```

#### staging (kilder)
Formål: Standardisere kolonnenavn, datatyper, trimme/null-håndtere, fjerne duplikater.
Views

#### intermediate (transformasjonser)
Formål: Joiner på tvers av kilder, beriker og aggregerer.

#### marts (forretnings-/analyselag)
Formål: Fakta- og dimensjonstabeller for rapportering og BI.
