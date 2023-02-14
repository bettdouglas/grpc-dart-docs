---
sidebar-position: 2
---

# Deploying to Google Cloud Run

When thinking about this site, I thought it'd be as an extra, to deploy the service online so that you don't need `localhost` anymore, and maybe even ship your app to Flutter Web. And what easier way to ship experimental servers easily than with Google's Cloud Run. 

Google Cloud Run is a service that enables you to run stateless containers on top of Google's scalable infrastructure. It enables you to easily deploy services that don't require persisting of state within the application logic. 
This is well suited for CRUD api's which talk to databases which are persistent on another service offering like Cloud SQL. 

![Google Cloud Run. How it works](https://cloud.google.com/static/run/docs/images/cloud-run-service.svg)

The Advantages we get with Cloud Run are:
 - Unique HTTPS endpoint for every service. 
 - Fast requests with autoscaling and downscaling depending on the amount of traffic being sent to the service. 
 - Traffic management.
 - Service versioning. e.g v1,v2 etc with easy support for rollbacks. 
 - Pay per use. You're only pay for what you use. i.e the amount of time your container is running. When there's no requests going to your service, Cloud Run scales to zero containers. 

I think it's the best serverless you can easily use to serve your apps. Also when you're on the Free tier, you have 2 million requests free per month. Then on other tiers, you pay $0.4/million requests. That's super-generous. Thanks Google. 


According to Cloud Run, there are languages which are supported out of the box. e.g Java, NodeJS, Go, Python, PHP, Ruby etc. 

Dart isn't a supported language, but the good thing is, as long as you have a Dockerfile in your project directory, we can deploy the service to Cloud Run. It's all based on containers. 

## Docker 
Docker is a technology for creating containerized applications that can be run in any container supported environment. 
In our case, we'll use Docker to ensure that everything runs well locally and then later deploy it to Cloud Run. If you cannot run Docker for some reason, or you don't know what Docker is, you can just use the provided Dockerfile to build your app. 

In a nutshell, Docker is a file which consists of steps that you'd need to run to make sure your software can be deployed on a clean OS without anything installed. In our case, that'll mean installing the dart-sdk, running pub-get etc. 
The advantage of the Docker ecosystem, is we have pre-build images that we can import and use to make our lives easier. These images are stored on [Docker Hub](https:hub.docker.com) and you can plug them in into your Dockerfile workflow. 

As an example, imagine you want to run a dart program in a newly installed OS on your computer. You'd need to install the download and install the dart-sdk, make sure the command dart is available for use on the `command line` etc. 

=

```Dockerfile
# Use latest stable channel SDK.
FROM dart:stable AS build

# Resolve app dependencies.
WORKDIR /app
COPY pubspec.* ./
RUN dart pub get

# Copy app source code (except anything in .dockerignore) and AOT compile app.
COPY . .
RUN dart compile exe bin/server.dart -o bin/server

# Build minimal serving image from AOT-compiled `/server`
# and the pre-built AOT-runtime in the `/runtime/` directory of the base image.
FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/bin/server /app/bin/
COPY --from=build /app/data/ /app/data/

# Start server.8080
EXPOSE 8080
CMD ["/app/bin/server"]
```


