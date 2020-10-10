FROM google/dart:latest as build

WORKDIR /app
ADD pubspec.* /app/
RUN dart pub get
ADD . /app
RUN dart pub get --offline
RUN dart analyze --fatal-infos
RUN mkdir build
RUN dart compile exe -o build/piwigo_sync bin/piwigo_sync.dart

FROM alpine:latest
COPY --from=build /app/build/piwigo_sync /bin/
RUN ls -lsa /bin | grep piwigo
RUN ldd /bin/piwigo_sync
