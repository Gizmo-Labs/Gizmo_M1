## 📌 Verwendung :

- Zuerst muss klar sein, auf welche Art das Widget bereitgestellt werden soll.
- Es kann auf der SD-Karte gespeichert werden. Diese muss dann aber immer im Sender stecken!
- Besser scheint die Übertragung direkt in den Senderspeicher.

## 📌 Zuerst eine Beschreibung für die SD-Karte

### ⚠️ Die SD-Karte muss im Format "FAT32" formatiert sein!

-  **Nur** den Ordner "scripts" auf die SD-Karte kopieren
-  Die Karte muss mit ihrem Aufdruck nach ⚠️️**hinten**⚠️ in den Sender gesteckt werden.
-  Im Sender unter ↪️**General** den Punkt ↪️**Scripte** auf ↪️**SD-Karte** stellen. 

![General Settings for SD.png](Graphic%2FGeneral%20Settings%20for%20SD.png)

- Wir wechseln nun zum ↪️**Datei-Manager**.
- Dort sollten wir nun unseren Ordner ↪️**scripts** sehen.
- Hat alles geklappt, sehen wir unsere Widgets mit ihrem Klartextnamen.

![Scripts on SD-Card.png](Graphic%2FScripts%20on%20SD-Card.png)

## 📌 Und dann für das Speichern im Sender

- ⚠️️**Zuerst**⚠️ den Sender einschalten! ⚠️️**Nicht**⚠️ im Bootlader-Modus!
- Dann per USB-Kabel mit dem Rechner verbinden.
- Den Punkt ↪️**Ethos Suite** wählen.

![USB Connection.png](Graphic%2FUSB%20Connection.png)

- Nun sollten im Betriebs-System (hier Windows 11) die Laufwerke auftauchen.
- FLASH ist dabei der Flash-Speicher des Senders. Diesen benötigen wir nicht.
- NAND ist der eigentliche Senderspeicher. Diesen wollen wir nutzen.
-  **Nur** den Ordner "scripts" auf das Laufwerk ↪️**NAND** kopieren

![Drives on PC.png](Graphic%2FDrives%20on%20PC.png)

- Nun können wir den Sender wieder vom PC abstecken.
- Im Sender unter ↪️**General** den Punkt ↪️**Scripte** auf ↪️**Sender** stellen. 

![General Settings for NAND.png](Graphic%2FGeneral%20Settings%20for%20NAND.png)

## 📌 Nun die Konfiguration des Widgets

- Für die weiteren Schritte wird ein gebundenes Modell vorausgesetzt!
- ⚠️**Zu Beginn zuerst den Sender einmal neu starten**⚠️


- Im ersten Schritt wird in der Maske "Bildschirm konfigurieren" ein neuer erstellt.
- Dieser ⚠️️**muss**⚠️ vom Typ Vollbild sein. Das Widget wurde ⚠️️**nur**⚠️ dafür programmiert.

![Display Settings.png](Graphic%2FDisplay%20Settings.png)

- Dann auf ↪️**Konfigurieren** klicken.
 
![Widget Configuration.png](Graphic%2FWidget%20Configuration.png)

- Es öffnet sich die Konfigration für das Widget
- Unter ↪️**Widget** unser ↪️**Gizmo M1** auswählen.
- Der ↪️**Titel** ⚠️️**muss**⚠️ auf AUS gestellt werden.
- Ist dies nicht der Fall, erscheint eine Klartext-Fehlermeldung im Widget!
- In den beiden Telemetrie-Feldern können nun die vom OMP Hobby M1<br>
  übertragenenen Parameter ausgewählt werden.
- ⚠️Modell muss gebunden sein⚠️
- ⚠️️Eventuell zuerst im Menü "Telemetrie" die Sensoren suchen⚠️

![Configuration Screen.png](Graphic%2FConfiguration%20Screen.png)

- Das Anzeigefeld ↪️**MODE** zeigt die ↪️**Flugphase** an.
- Wo diese definiert wird, sollte jeder Pilot wissen!
---
- Das Anzeigefeld ↪️**Flugzeit** zeigt die ⚠️**erste**⚠️ hinterlegte Stoppuhr an!
- ⛔**Ende der Durchsage**⛔ Und viel Spaß damit! 

![Only Widget.png](Graphic%2FOnly%20Widget.png)