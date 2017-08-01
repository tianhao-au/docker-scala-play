# Scala and Play framework Docker Image

## Introduction
1. Dockerhub: [ysihaoy/scala-play](https://hub.docker.com/r/ysihaoy/scala-play/)
2. Docker image for Scala, Play framework and SBT project with different versions

## Supported tags (combinations of Scala, Play and SBT) and Dockerfile links
* 2.12.3-2.6.2-sbt-0.13.15

* 2.12.2-2.6.0-sbt-0.13.15, [Dockerfile](https://github.com/ysihaoy/docker-scala-play/blob/2.12.2-2.6.0-sbt-0.13.15/Dockerfile)

* 2.11.8-2.5.4-sbt-0.13.11, [Dockerfile](https://github.com/ysihaoy/docker-scala-play/blob/2.11.8-2.5.4-sbt-0.13.11/Dockerfile)

* 2.11.7-2.4.6-sbt-0.13.8, [Dockerfile](https://github.com/ysihaoy/docker-scala-play/blob/2.11.7-2.4.6-sbt-0.13.8/Dockerfile)

## How to use in your Scala SBT project
1. Choose a image tag, e.g `2.12.2-2.6.0-sbt-0.13.15` is highly recommended instead of `latest` version

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
  FROM ysihaoy/scala-play:2.12.2-2.6.0-sbt-0.13.15

  # caching dependencies
  COPY ["build.sbt", "/tmp/build/"]
  COPY ["project/plugins.sbt", "project/build.properties", "/tmp/build/project/"]
  RUN cd /tmp/build && \
    sbt compile && \
    sbt test:compile && \
    rm -rf /tmp/build

  # copy code
  COPY . /root/app/
  WORKDIR /root/app
  RUN sbt compile && sbt test:compile

  EXPOSE 9000
  CMD ["sbt"]
  ```

## Optimisation of the build time
In order to have fast CI (continuous integration) build process, sample of your `project/build.properties`, `project/plugins.sbt` and `build.sbt` should be like:
1. `project/build.properties`
  ```
  sbt.version = 0.13.15
  ```

2. `project/plugins.sbt`
  ```
  // The Play plugin
  addSbtPlugin("com.typesafe.play" % "sbt-plugin" % "2.6.0")
  ```

3. `build.sbt`
  ```
  scalaVersion := "2.12.2"
  ```

## Note: Since `activator` was EOL-ed on May 24, 2017, instead of using the Activator command, make sure you have sbt 0.13.13 (or higher), and use the “sbt new” command, providing the name of the template. Click [here](https://www.lightbend.com/community/core-tools/activator-and-sbt) to see more.

## Happy hacking Scala, Play framework and Docker
