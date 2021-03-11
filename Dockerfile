FROM mcr.microsoft.com/dotnet/core/sdk:3.1-alpine AS build
WORKDIR /app

RUN apk add git

# Separate layers here to avoid redoing dependencies on code change.
RUN git clone --depth 1 https://github.com/prometheus-net/docker_exporter.git
RUN cd docker_exporter
RUN dotnet restore
RUN dotnet publish -r linux-musl-arm64 -c Release -o out

FROM mcr.microsoft.com/dotnet/runtime:3.1-alpine-arm64v8 AS runtime
WORKDIR /app
COPY --from=build /app/docker_exporter/out .

ENTRYPOINT ["./docker_exporter"]
