# build environment
FROM node:alpine as buildnode
WORKDIR /app
COPY client/package.json ./
COPY client/yarn.lock ./
COPY ./client/src ./src
RUN yarn
RUN yarn build

FROM golang AS buildgo
WORKDIR /go/src/app/
COPY server/ ./
RUN go build -o cmd/server/server cmd/server/main.go 

FROM alpine
COPY --from=buildgo /go/src/app/cmd/server/ /app/
COPY --from=buildnode /app/dist /app/static/
CMD ["/app/server"]
EXPOSE 80
EXPOSE 9000
