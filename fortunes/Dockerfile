FROM docker/whalesay:latest
LABEL Name=thefortunes Version=1.0.0
RUN apt-get -y update && apt-get install -y fortunes
CMD ["sh", "-c", "/usr/games/fortune -a | cowsay"]
