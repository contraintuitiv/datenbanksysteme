#1: Welche Tabellen hat die Datenbank?
city, country und Countrylanguage
#2: Welche Spalten in welchen Tabellen sind Fremdschlüssel?
in country Tabelle code, in CountryLanguage countrycode
#3: Welche Datentypen werden in den verschiedenen Spalten verwendet?
String und Integer
#4: Gibt es Beispiele für den Einsatz von NULL?
ja es wurde in spalte indepyear Tabelle country viel eingesetzt und ywar viel mehr.

#5: Gibt es Redundanzen in den gespeicherten Daten?
ich glaub ja, da im county Tabelle gibt es ein Spalte die heißt code2
auch Hauptstadt "capital" ist eine Form von Redundanz
city Tabelle kann von country ein fremdschlüssel vererben aber nicht umgekehrt.