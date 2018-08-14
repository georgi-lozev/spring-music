FROM openjdk:8-jdk

COPY . /spring-music
WORKDIR /spring-music

EXPOSE 8080

RUN ./gradlew clean assemble

CMD java -jar build/libs/spring-music-1.0.jar
