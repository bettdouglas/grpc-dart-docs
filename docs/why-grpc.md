---
sidebar_position: 1
---

# Why use gRPC

Let's discover **gRPC and how to use it to build backend servers**.

## About

Over the years after playing around with gRPC, with the little lack of documentation on how to use gRPC to make your apps communicate with Flutter, I decided to make an Open-Source site which could serve as reference to anyone wanting to spin-up servers using gRPC.

This aims to be a collection of guides, tutorials, best practices, tips & tricks on how to best use gRPC with Dart & Flutter. 

There are many reasons why you'd want to use gRPC over REST.
  1. **Speed**
  > “gRPC is roughly 7 times faster than REST when receiving data & roughly 10 times faster than REST when sending data for this specific payload. This is mainly due to the tight packing of the Protocol Buffers and the use of HTTP/2 by gRPC.” [gRPC vs. REST: How Does gRPC Compare with Traditional REST APIs?](https://blog.dreamfactory.com/grpc-vs-rest-how-does-grpc-compare-with-traditional-rest-apis/)
  2. **Protocol Buffers**
  > Protocol buffers provide a language-neutral, platform-neutral, extensible mechanism for serializing structured data in a forward-compatible and backward-compatible way. It's like JSON, except it's smaller and faster, and it generates native language bindings [Overview of Protocol Buffers | Google Developers](https://developers.google.com/protocol-buffers/docs/overview)
  Google's protoc is used to compile protocol buffers and generate server & client interfaces which shall be used in implementing the server logic and communication between the server and the client. 
  As an example, you decide to model a Person with three attributes in protocol buffers.
  ```lang=protoc
message Person {
    optional string name = 1;
    optional int32 id = 2;
    optional string email = 3;
}
  ```
  When you generate dart bindings, it shall generate a dart class called `Person` with the properties defined in the message(name,id,email) which you can instantiate as 
  ```dart
  final person = Person(name: 'Collin Tiler',id: 1,email: 'c.tiler@xmail.com');
  ```
  When you generate Java bindings, it generates classes which you can instantiate as 
  ```java
Person john = Person.newBuilder()
    .setId(1234)
    .setName("John Doe")
    .setEmail("jdoe@example.com")
    .build();
  ```
  3. **Broad language support**
  While the focus of this mini-blog will be implementing gRPC services in Dart, gRPC has broad language support. 
  It’s widely supported in most modern languages and frameworks, including Java, Ruby, Go, Node.js, Python, C#, and PHP.
  So this means you can implement your server in Dart, and call it with the generated client in your favorite language. If your company used Python to implement the server, given the protocol buffer server definitions, you can generate the client bindings in Dart and make rpc calls to your server in Flutter/Dart. 

  4. **gRPC is designed for low latency and high throughput communication.**
  While it's great for lightweight microservices where efficiency is critical, all other services e.g Mobile Devices, IoT devices, Web Browsers also benefit from this low latency. This means refreshes will be fast, startup times will be fast etc. 
  

> Apart from this few benefits over REST, many Flutter Developers and junior developers would benefit from using one language, Dart to write backend services as well as write the UI. The Dart eco-system is growing widely everyday and I think many people would benefit from learning things the different way. 

This aims to be a collection of server & client examples and guides on how to use gRPC in your **[Flutter](https://flutter.dev/)** apps.

### What you'll need

- Some working knowledge of Dart/Flutter. 
- Some knowledge of how applications communicate over the internet. 

## What we aim to cover
  1. Creating a simple gRPC service using Dart that can handle fetching all, searching by properties etc.[X]
  2. Create a simple Flutter client which can talk to the server.[X]
  3. Create real-world gRPC services that perform CRUD tasks and store the data in a database like PostgreSQL,MongoDB & ArangoDB.[X]
  4. Implementing Authentication. (JWT, Firebase, Login, Registration) 
  5. How to use Interceptors to automate repetetive logic like authentication, modifying metadata, logging, error-handling etc(Server-Side & Client Side)
  6. Error handling.
  7. Many More. 

<!-- ## Start your site -->
