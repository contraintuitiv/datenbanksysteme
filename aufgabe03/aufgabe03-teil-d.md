Notiz: Ich habe überprüft, ob auch Jobs kommentiert werden können.

```
SELECT * FROM comments WHERE parent IN (SELECT id FROM jobs)
```
-> nein