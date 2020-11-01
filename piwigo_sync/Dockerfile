FROM google/dart:latest as build
WORKDIR /app
ADD pubspec.* /app/
RUN dart pub get
ADD . /app
RUN dart pub get --offline
RUN dart analyze --fatal-infos
RUN mkdir build
RUN dart compile exe -o build/piwigo_sync bin/piwigo_sync.dart

FROM gcr.io/google-appengine/debian10:latest
COPY --from=build /app/build/piwigo_sync /usr/bin/
COPY entrypoint.sh /usr/bin/entrypoint.sh
ENTRYPOINT [ "/usr/bin/entrypoint.sh" ]
