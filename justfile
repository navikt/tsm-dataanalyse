# Sjekk at alt koden ser bra ut og er klar for å legges til i git
lint:
    uv run --only-group lint pre-commit run --all-files --color always

# Linter sql-filer
#lint:
#	uv run sqlfluff lint models

# Formaterer sql-filer
#format:
#	uv run sqlfluff format

# Logger inn i GCP
login:
    gcloud auth login --update-adc