FROM gcr.io/spinnaker-marketplace/gradle_cache AS builder
MAINTAINER delivery-engineering@netflix.com

ENV GRADLE_USER_HOME /gradle_cache/.gradle

COPY . workdir/

WORKDIR workdir

RUN ./gradlew gate-web:installDist -x test

FROM openjdk:8

COPY --from=builder /workdir/gate-web/build/install/gate /opt/gate

RUN adduser --disabled-login --system spinnaker

USER spinnaker

CMD ["/opt/gate/bin/gate"]
