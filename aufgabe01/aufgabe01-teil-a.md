# 1: Welche Tabellen hat die Datenbank?
city, country und countrylanguage

# 2: Welche Spalten in welchen Tabellen sind Fremdschlüssel?
in country Tabelle `capital`, in countrylanguage `countrycode`

# 3: Welche Datentypen werden in den verschiedenen Spalten verwendet?
`boolean`, `real`, `character`, `text`, `smallint`, `integer`, `numeric`

# 4: Gibt es Beispiele für den Einsatz von NULL?
ja es wurde in spalte indepyear Tabelle country viel eingesetzt und ywar viel mehr.

# 5: Gibt es Redundanzen in den gespeicherten Daten?
countrycode in city könnte Referenzen sein (in countrylanguage immerhin foreign key). city Tabelle kann von country ein fremdschlüssel vererben aber nicht umgekehrt.

ich glaub ja, da im county Tabelle gibt es ein Spalte die heißt code2 _(hat aber andere Daten, also nicht wirklich redundant, oder?)_
auch Hauptstadt "capital" ist eine Form von Redundanz _(ist Fremdschlüssel)_
