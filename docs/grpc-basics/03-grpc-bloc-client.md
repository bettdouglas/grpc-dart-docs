---
sidebar_position: 2
description: Creating a Flutter Client using Flutter BLOC.
---

# Flutter client using BLOC 

In this guide, we'll create a Flutter application that will make calls to the server. 
We'll implement 
    - ListHospitals
    - GetHospital functionality
    - SearchHospitals functionality. 

In this guide, we'll use (very_good_cli)[https://pub.dev/packages/very_good_cli], [mason](https://pub.dev/packages/mason_cli).

Mason is a code generator for Dart and any projects. It generates code based on templates that are defined. These templates are available on (BrickHub)[https://brickhub.dev/]. Since we'll be using the feature folder style, we have a Mason brick/template that will assist with that. 

We'll use (feature_brick)[https://brickhub.dev/bricks/feature_brick/0.6.1] to assist us in easily generating the folder structure using the feature structure so that we can implement the functionality with ease. 

## Getting Started

We'll create a Flutter application using the command `flutter create african_hospitals_bloc_client`.

Once we've created the application, let's implement the server provided features. 
Using mason in your project needs initialization. Once we've activated mason, we can use the various bricks available on https://brickhub.dev. 

If it's your first time using mason, we need to install it globally. Installing it is pretty easy. 

```cmd
dart pub global activate mason_cli
```

Once activated, we need to activate it for our current project. Running the command 
```cmd
mason init
``` 
enables your current project to use mason. So make sure you run that command as well. 

Let's add the feature_brick to our current project so that we can easily use it. 

```cmd
mason add feature_brick
```
You should see the following after running that command. 

```
✓ Installing feature_brick (3.2s)
✓ Compiling feature_brick (0ms)
✓ Added feature_brick (1ms)
```

### ListHospitals feature. 

For this, we'll make a simple ListView when the data is loaded, a `CircularProgressIndicator` when loading and `Container` with error message in case an error occurs. 

If you're not farmiliar with BLOC library, I'd suggest going to https://bloclibrary.dev/ to learn more about it, since the library has some concepts which you need to be farmiliar with. At the core, bloc library pattern has the concept of `events` and `states`. Events are events that come from user interaction e.g 
- Clicking of a button
- start of something at initState

These are the fundamental building blocks of the bloc pattern. 
We then have a BLOC which is responsible for handling events and changing states as it processes the various events. 

You can see how bloc transforms the events from the UI to various states changes which the UI will react to.

![Flow of Events](https://bloclibrary.dev/assets/bloc_architecture_full.png)

Let's say someone clicking a button to like a video, the event will be `LikeVideoEvent(videoId: 1)` then the BLOC will change the state of the event to `LikingVideoState`, `VideoLiked` or `FailedToLikeVideo`. 

For the ListHospitals feature, we're going to have a single event called ListHospitalsEvent which be transformed into either `Loading`, `Loaded` or `LoadFailure` states. When the state is Loading, we'll show a loading indicator, when the state is LoadFailure, we'll want to show the error message together with the stacktrace and then when the state is Loaded, we'll want to show the List of hospitals in our UI. 

In this example, let's use mason and [flutter_bloc_feature](https://brickhub.dev/bricks/flutter_bloc_feature/0.2.1) brick to create the folder structure so that we can implement the ListHospitals feature. 

Let's add the flutter_bloc_feature brick into our project. 
```bash
mason add flutter_bloc_feature
```

After installing the brick, let's use it to create a proper folder structure that uses best practices by the bloc package author. 
```bash
mason make flutter_bloc_feature --name list_hospitals --type bloc --style freezed
```

Running that would create a new folder that looks like the following. 
```
── list_hospitals
│   ├── bloc
│   │   ├── list_hospitals_bloc.dart
│   │   ├── list_hospitals_event.dart
│   │   └── list_hospitals_state.dart
│   ├── list_hospitals.dart
│   └── view
│       ├── list_hospitals_page.dart
│       └── view.dart
```

You'll see we have the file containing the various states we'll define, the various events and the bloc which is where we'll handle our logic. The view folder is also separated from bloc which is quite neat. 

For the ListHospitals feature, we'll only have one event that'll just tell the bloc to fetch the list of hospitals from the server once the ListHospitalsPage is loaded. 

```dart
part of 'list_hospitals_bloc.dart';

@freezed
class ListHospitalsEvent with _$ListHospitalsEvent {
  const factory ListHospitalsEvent.started() = _Started;
}

```

To define the various states which the app can be in, we'll have 
1. Initial state -> once the app starts.
2. Loading state -> when loading list of hospitals
3. Loaded state -> when list of hospitals have been obtained from the server. 
4. Failure state -> when the API call fails with an error message. 

To handle these various states, we'll use a feature of freezed called Sealed Types/Union Types. These enable us to declare a finite 


```dart
part of 'list_hospitals_bloc.dart';

@freezed
class ListHospitalsState with _$ListHospitalsState {
  const factory ListHospitalsState.initial() = _Initial;
  const factory ListHospitalsState.loading(String message) = _Loading;
  const factory ListHospitalsState.loaded({
    required List<Hospital> hospitals,
  }) = _Loaded;
  const factory ListHospitalsState.failure({
    required String error,
    StackTrace? stackTrace,
  }) = _Failure;
}
```

We'll need to add the packages freezed_annotation to dependecies and freezed & build_runner as dev_dependencies. 
Also since I'm planning to write another guide using riverpod and more state management libraries, I decided to copy the gRPC generated client code to it's own package for easier importation and separate management of the client code. 

In the end, our pubspec.yaml looks like below

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_bloc:
  grpc: 
  freezed_annotation:  
  african_hospitals_client: 
    path: ../../african_hospitals_client
  cupertino_icons: ^1.0.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  bloc_test: 
  build_runner: 
  freezed: 
```

After running ```flutter pub get```, let's start build_runner since freezed depends on code generation to make our lives easier. 