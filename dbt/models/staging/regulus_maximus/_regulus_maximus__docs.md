{% docs base_sykmeldinger %}

Base-modell for sykmeldinger fra regulus_maximus. Dette er den eneste modellen som leser fra kilden.

Kilden i bigquery oppdateres en gang hver natt via federated queries i gcp.

Modellen henter ut felter som finnes på alle sykmeldingstyper, og sender rå `sykmelding`- og
`metadata`-JSON videre til én stg-modell per type. 
Modellen er `ephemeral`: legges inn som CTE i stg-modellene.

{% enddocs %}

{% docs stg_sykmeldinger_digital %}

Digitale sykmeldinger (DIGITAL) med typespesifikke felter. Strukturen for digitale sykmeldinger
forventes å endre seg, så nye DIGITAL-felter legges til her (og i marts ved behov).

{% enddocs %}

{% docs stg_sykmeldinger_xml %}

XML-sykmeldinger (XML) fra EPJ via eMottak, med typespesifikke felter.

{% enddocs %}

{% docs stg_sykmeldinger_papir %}

Papirsykmeldinger (PAPIR) med typespesifikke felter.

{% enddocs %}

{% docs stg_sykmeldinger_utenlandsk %}

Utenlandske sykmeldinger (UTENLANDSK) med typespesifikke felter.

{% enddocs %}
