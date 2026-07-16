#Stage 1: Compile go into binary executable
FROM golang:1.26.2-alpine AS executable
WORKDIR /services/dashboard
COPY go.mod .
RUN go mod download
COPY . .
RUN --mount=type=cache,target=/root/.cache/go-build \
CGO_ENABLED=0 go build -o /services/dashboard-executable

#Stage 2: Only single binary executable
FROM alpine:3.19 AS final
WORKDIR /dashboard
RUN apk --no-cache add ca-certificates
COPY --from=executable /services/dashboard-executable .
RUN chmod +x ./dashboard-executable
EXPOSE 8081
CMD [ "./dashboard-executable" ]