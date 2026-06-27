#Stage 1: compile into single executable bimary
FROM golang:1.26.2-alpine AS executable
WORKDIR /services/worker
COPY go.mod .
RUN go mod download
COPY . .
RUN mount=type=cache,target=/root/.cache/go-build \
CGO_ENABLED=0 go build -o /services/worker-executable


#Stage 2: Only executable file
FROM scratch
WORKDIR /worker
COPY --from=executable /services/worker-executable .
CMD [ "./worker-executable" ]