# Displaytext
## Image Versionen
displaytext:v1
displaytext:latest

### Beschreibung
Figlet macht Textausgaben auf der Konsole. Standardmässig wird der Text BFSU ausgegeben. Der Text kann mit einem String Parameter überschrieben werden.

### Konfigurationsoptionen
-f \[font\] liefert einen entsprechenden Font gemäs Möglichkeiten von [figlet](http://figlet.org).

Folgendes Beispiel verwendet Schrift script und gibt den Text Heureka aus:

	docker run --rm dominikreussbzu/displaytext -f script Heureka
``` 
>    __  __                     __ <br>
>   / / / /__  __  __________  / /______ _<br>
>  / /_/ / _ \/ / / / ___/ _ \/ //_/ __ `/<br>
> / __  /  __/ /_/ / /  /  __/ ,< / /_/ /<br>
>/_/ /_/\___/\__,_/_/   \___/_/|_|\__,_/<br> 
<br>
```

