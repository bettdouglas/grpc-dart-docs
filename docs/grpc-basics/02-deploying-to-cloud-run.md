---
sidebar-position: 1
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

Dart isn't a supported language, but the good thing is, as long as you have a Dockerfile in your project directory, we can deploy the service to Cloud Run. It's all based on containers. We'll have to create a Dockerfile with instructions on how to deploy our code to Cloud Run and many other serverless providers. They normally use Buildpacks, Procfiles or Dockerfiles. But Dockerfiles seem to be supported everywhere. 

## Docker 
Docker is a technology for creating containerized applications that can be run in any container supported environment. 
In our case, we'll use Docker to ensure that everything runs well locally and then later deploy it to Cloud Run. If you cannot run Docker for some reason, or you don't know what Docker is, you can just use the provided Dockerfile to build your app. 

In a nutshell, Docker is a file which consists of steps that you'd need to run to make sure your software can be deployed on a clean OS(e.g Ubuntu or Ubuntu with Dart already installed). You can think of it as a series of steps we need to run to ensure our software runs. 

In our case, that'll mean installing the dart-sdk, running pub-get etc. 
The advantage of the Docker ecosystem, is we have pre-build images that we can import and use to make our lives easier. These images are stored on [Docker Hub](https:hub.docker.com) and you can plug them in into your Dockerfile workflow. 

As an example, imagine you want to run a dart program in a newly installed OS on your computer. You'd need to install the download and install the dart-sdk, make sure the command dart is available for use on the `command line` etc. 

These are the same commands we'll put on a `Dockerfile` and use containers to ease deployment of our apps. 


```Dockerfile
# Use latest stable channel SDK.
FROM dart:stable AS build

# Resolve app dependencies.
WORKDIR /app
COPY pubspec.* .
RUN dart pub get

# Copy app source code (except anything in .dockerignore) and AOT compile app.
COPY . .
RUN dart pub get
RUN dart compile exe bin/hospitals_server.dart -o bin/server

# Build minimal serving image from AOT-compiled `/server`
# and the pre-built AOT-runtime in the `/runtime/` directory of the base image.
FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/bin/server /app/bin/
COPY data/hospitals.csv app/data/hospitals.csv

# Start server.8080
EXPOSE 8080
CMD ["/app/bin/server"]
```

## Description of the Dockerfile. 

```
FROM dart:stable AS build
```
This command tells Docker to import the `dart:stable` image from Dockerhub for us to use. Since we don't want to manually create an environment from scratch, because containers come a runtime only, we can use an already created image with the dart-sdk ready for us to use. We're also calling this build step `build` so that we can reference artifacts from this step later on. 

```
1. WORKDIR /app
2. COPY pubspec.* ./
3. RUN dart pub get
```

1. The commands above tell Docker that we'll be working in a directory called /app.
2. This copies the pubspec.yaml & pubspec.lock into the container. 
3. We run the command `dart pub get` to get dependencies. 


```
1. COPY . .
2. RUN dart compile exe bin/hospitals_server.dart -o bin/server
```

1. We copy all the source code to the container.
2. We create an executable file at directory /bin called server. This will enable us to run the dart program by `./bin/server/`


```
1. FROM scratch
2. COPY --from=build /runtime/ /
3. COPY --from=build /app/bin/server /app/bin/
4. COPY data/hospitals.csv app/data/hospitals.csv
```

1. In the first line of our Dockerfile, we needed the dart-sdk to compile our program. The dart-sdk image is about 700MB because it includes alot of what is needed for the dart-sdk to compile, test etc. Since we've compiled our application to an executable file, we no longer need the dart-sdk here. You can run `./bin/server/` and it'll run whether the dart-sdk is available or not. 
So using the line `FROM scratch`, this set's up a new environment which is really lightweight. It's just 142 bytes according to [this article](https://codeburst.io/docker-from-scratch-2a84552470c8). 
So the only thing we'll need to do is copy anything from the previous build steps i.e the server executable we built into this new build step. 
2. We're copying /runtime/ to the root of the container from `build` step 1. 
3. We're copying the server executable to `/app/bin/`
4. We're copying the csv of hospitals to `/app/data/`


```
1. EXPOSE 8080
2. CMD ["/app/bin/server"]
```

1. At step 1, we're exposing port 8080 when the container starts since this is where it'll receive traffic from. Since containers run in a contained world, if we started the container without telling the container to expose port 8080, the container would not be able to receive any sort of traffic. But we have to specify the ports we want to open to the world. Just like you'd specify which ports you'd want to open on a virtual machine/host machine. 

2. This command is the last step when building our image and it starts the container by running the executable we built. 

## Building and running the image using Docker

If you have Docker installed and enabled, you could try building the image and see for yourself. 

After having a Dockerfile in place, it has to be built so that it can be deployed. The result of building a Dockerfile is a Docker image. This image can be deployed to container repositories for easy access when deploying, sharing with the community e.g via https:hub.docker.com .

### Build our image

Going to the root of our directory where the server is running. i.e where pubspec.yaml is, 


```bash
docker build -t hospitals-grpc-server .
```
Once built, you can see the image created via `docker image ls`. You can see that the image size is 24MB which is really impressive. 

### Running the image
When you run an image, you get a container which is an isolated service/services which are running but nothing touches your local machine. It runs containerized in it's own environment provided by Docker. 
The only way a container can be accessed is through opening ports. When you expose ports, traffic can now enter the container. 

To start a container from the `hospitals-grpc-server` image, we run:
```bash
docker run -e PORT=8080 -t hospitals-grpc-server
```

This starts the container with traffic serving on port 9000. The `-e PORT=8080` is a way of specifying environment variables that will be passed to the container when it's running. 

Once running, you can check on which containers are running using the command `docker container ls`.
You'll see something that looks like the following. 
```
CONTAINER ID   IMAGE                   COMMAND                  CREATED         STATUS                PORTS      NAMES
4da06da386ea   hospitals-grpc-server   "/app/bin/server"        3 minutes ago   Up 3 minutes          8080/tcp   epic_gauss
```
When you try reaching the service, you'll notice that it's not accessible. This is because the container is running inside the container and not visible to the external world. To make it accessible, let's run the command again while exposing the PORT 8080 to localhost. 

```bash
docker run -e PORT=8080 -p 8080:8080 -it hospitals-grpc-server
```

The argument `-p 8080:8080` means expose the 8080 PORT on localhost and redirect all traffic on localhost to 8080. It creates a mapping of the container port to localhost port. 
If you inspect the running containers now, you'll see we have a different line on the PORTS section. 
```
CONTAINER ID   IMAGE                   COMMAND             CREATED              STATUS              PORTS                    NAMES
d0218c5247f1   hospitals-grpc-server   "/app/bin/server"   12 seconds ago       Up 10 seconds       0.0.0.0:8080->8080/tcp   flamboyant_robinson
b76864b501f0   hospitals-grpc-server   "/app/bin/server"   About a minute ago   Up About a minute   8080/tcp                 gracious_tereshkova
```

You'll see on container named `flamboyant_robinson`, there's a mapping between 0.0.0.0:8080 which is localhost and 8080 which is the container PORT. This enables us to send traffic to the container on PORT 8080. 

If you run the tests in server/hospital_service_test.dart, you'll see that they pass well. 

## Deploying to Cloud Run. 

Now that we've tested the Dockerfile works, we can go ahead and deploy to Google Cloud Run. 

The steps to deploying to Cloud Run are really easy once initial setup is done. 
1. Install `gcloud` on your machine. 
`https://cloud.google.com/sdk/docs/install`

2. Login to `gcloud`.
```gcloud init```

3. Setup to which project you want the service deployed to
``` gcloud config set project PROJECT_ID```

3. Deploy our code to `gcloud`. 
```gcloud run deploy```
You'll be asked for the region and what the name of the service should be. 

```
Deploying from source. To deploy a container use [--image]. See https://cloud.google.com/run/docs/deploying-source-code for more details.
Source code location (/Users/douglasbett/Documents/dev/grpc-dart-docs/examples/african_hospitals/server):  
Next time, use `gcloud run deploy --source .` to deploy the current directory.

Service name (server):  hospitals-grpc-server
This command is equivalent to running `gcloud builds submit --tag [IMAGE] /Users/*/Documents/dev/grpc-dart-docs/examples/african_hospitals/server` and `gcloud run deploy hospitals-grpc-server --image [IMAGE]`

Building using Dockerfile and deploying container to Cloud Run service [hospitals-grpc-server] in project [issues-project-366808] region [europe-west6]
✓ Building and deploying... Done.                                                                                                                                                    
  ✓ Uploading sources...                                                                                                                                                             
  ✓ Building Container... Logs are available at [https://console.cloud.google.com/cloud-build/builds/0e0819f9-bb6f-43b3-ab22-8d9ef60928d6?project=334216854848].                     
  ✓ Creating Revision...                                                                                                                                                             
  ✓ Routing traffic...                                                                                                                                                               
Done.                                                                                                                                                                                
Service [hospitals-grpc-server] revision [hospitals-grpc-server-00002-guy] has been deployed and is serving 100 percent of traffic.
Service URL: https://hospitals-grpc-server-of5ogbihaa-oa.a.run.app
```

If everything goes okay, we'll have a serverless instance running on Cloud Run which can accept traffic on the provided url. Your url will be the one provided at

```
Service URL: https://hospitals-grpc-server-of5ogbihaa-oa.a.run.app
```

This is the URL we'll need to pass to our `ClientChannel` contructor so that we can access the gRPC service. Also note that we're using Cloud Run because it provides support for gRPC on serverless. This becomes important when streaming as well. 

The change which will need to happen is
```dart
final channel = ClientChannel(
    'hospitals-grpc-server-of5ogbihaa-oa.a.run.app',
    port: 443,
    // cloud run serves traffic on 443
    options: ChannelOptions(
    credentials: ChannelCredentials.secure(),
    // changed from ChannelCredentials.insecure(),
    ),
);
```

That's how we deploy to Google Cloud Run. The only challenging part I think was creating the Dockerfile, but once we have the Dockerfile ready, deploying the service is an easy task. 

