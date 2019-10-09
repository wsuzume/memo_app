FROM golang:alpine

USER root

COPY ./go/src/memo_app /go/src/memo_app
COPY ./elm /elm

WORKDIR /go/src/memo_app
RUN go build -o main
RUN mkdir /app \
  && cp /go/src/memo_app/main /app/main \
  && cp -r /elm/views /app/views \
  && cp -r /elm/assets /app/assets

WORKDIR /app
CMD ./main
