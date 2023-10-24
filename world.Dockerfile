FROM zls3434/wow-base:latest

WORKDIR /wowserver
RUN mkdir bin etc data logs

COPY ./dist/bin/worldserver /wowserver/bin/
WORKDIR bin

CMD ["./worldserver"]
