FROM openjdk:8-jdk
VOLUME "/mnt/logs"

ENV TZ=Asia/Shanghai

ENV JAVA_OPTS=""
ENV JAVA_HEAP_OPTS="-Xms2g -Xmx2g"

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY ./target /opt/target
WORKDIR /opt/target
RUN find -type f -name "*.jar" | xargs -I{} mv {} app.jar
ENTRYPOINT exec java $JAVA_HEAP_OPTS $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar app.jar