# Scala and Play framework Docker Image

## Introduction
1. Dockerhub: [ysihaoy/scala-play](https://hub.docker.com/r/ysihaoy/scala-play/)
2. Docker image for Scala, Play framework and SBT project with different versions

## How to use in your Scala SBT project
1. Choose a image tag, e.g `2.11.8-2.5.4-sbt-0.13.11` is highly recommended instead of `latest` version

2. Sample of your minimal project structure

  ```
  your-play-project
  │   build.sbt
  │   Dockerfile
  │
  ├───project
  |       build.properties
  |       plugins.sbt
  |
  ├───app
  │   │   ...
  |
  └───test
  ```

3. Sample of your `Dockerfile` should be like:

  ```
  FROM ysihaoy/scala-play:2.11.8-2.5.4-sbt-0.13.11

  # caching dependencies
  COPY ["build.sbt", "/tmp/build/"]
  COPY ["project/plugins.sbt", "project/build.properties", "/tmp/build/project/"]
  RUN cd /tmp/build && \
    activator compile && \
    activator test:compile && \
    rm -rf /tmp/build

  # copy code
  COPY . /root/app/
  WORKDIR /root/app
  RUN activator compile && activator test:compile

  EXPOSE 9000
  CMD ["activator"]
  ```

## Optimisation of the build
In order to have fast CI (continuous integration) build process, sample of your `project/build.properties`, `project/plugins.sbt` and `build.sbt` should be like:
1. `project/build.properties`
  ```
  sbt.version = 0.13.11
  ```

2. `project/plugins.sbt`
  ```
  // The Play plugin
  addSbtPlugin("com.typesafe.play" % "sbt-plugin" % "2.5.4")
  ```

3. `build.sbt`
  ```
  scalaVersion := "2.11.8"
  ```

## Happy hacking Scala, Play framework and Docker
