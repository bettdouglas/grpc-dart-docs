---
sidebar_position: 2
description: Creating a Flutter Client using Flutter BLOC.
---

# Flutter Client using BLOC 

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

After running ```flutter pub get```, let's start build_runner since freezed makes our lives easier through code generation. And it has many more useful utilities that make lives easier. Check it out on [pub.dev](pub.dev/packages/freezed). Especially union types, these make pattern matching really easy. 

After importing the `african_hospitals_client`, we'll use `RepositoryProvider` to inject the `HospitalServiceClient` into our app so that we access it when implementing the various blocs. 

```
import 'package:african_hospitals_bloc_client/list_hospitals/list_hospitals.dart';
import 'package:african_hospitals_client/african_hospitals_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final client = AfricanHospitalsClient.client(
      host: 'localhost',
      isSecure: false,
      port: 9980,
      interceptors: [],
    );
    return RepositoryProvider<HospitalServiceClient>(
      create: (context) => client,
      child: MaterialApp(
        title: 'Flutter gRPC Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const ListHospitalsPage(),
      ),
    );
  }
}
```

#### BLOC Implementation
To implement the bloc functionality, we'll need an instance of the HospitalServiceClient so that we can make network requests when an event 

```dart
import 'package:african_hospitals_client/african_hospitals_client.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grpc/grpc.dart';

part 'list_hospitals_event.dart';
part 'list_hospitals_state.dart';
part 'list_hospitals_bloc.freezed.dart';

class ListHospitalsBloc extends Bloc<ListHospitalsEvent, ListHospitalsState> {
  final HospitalServiceClient hospitalServiceClient;

  ListHospitalsBloc({
    required this.hospitalServiceClient,
  }) : super(const ListHospitalsState.initial()) {
    on<ListHospitalsEvent>((event, emit) async {
      await event.when(
        started: () async {
          try {
            emit(
              const ListHospitalsState.loading('Fetching list of hospitals'),
            );
            // Send the request to the server
            final response = await hospitalServiceClient.listHospitals(
              ListHospitalsRequest(),
            );
            final hospitals = response.hospitals;
            emit(ListHospitalsState.loaded(hospitals: hospitals));
          } on GrpcError catch (e, st) {
            emit(
              ListHospitalsState.failure(error: e.toString(), stackTrace: st),
            );
          }
        },
      );
    });
  }
}
```


As you can see, on all ListHospitalEvents, we're going to change state to loading, once we have our data, we're going to change the state to HospitalsLoaded state. In case of a `GrpcError` error, we change the state to Failure with an error message.

In our UI, we'll need to handle the various states our app can be in. We'll use `BlocBuilder` to listen to the state changes of our BLOC and build our UI depending on the state. Let's see how freezed helps us map that out clearly. 

We're going to use the when clause generated by freezed. Freezed will generate callbacks which can return null or another value. These callbacks help us transform our various states into various elements. In our UI, we'll want to transform the states into widgets which map to the respective state we want to the user to see. 

As you can see below, 
1. When the state is initial, we return a `SizedBox`.
2. When the state is loading, we return a `CircularProgressIndicator`.
3. When the state is loaded, we get the list of hospitals via the callback and return `ListView` of hospitals.
4. When there's an error, we get access to the error and the stackTrace and return a `Column` with widgets which show the error. 


```dart

class ListHospitalsView extends StatelessWidget {
  const ListHospitalsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListHospitalsBloc, ListHospitalsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('African Hospitals'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: state.when(
              initial: () => const SizedBox(),
              loading: (msg) => const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
              loaded: (hospitals) {
                return ListView.builder(
                  itemBuilder: (context, index) => ListTile(
                    title: Text(hospitals[index].name),
                  ),
                  itemCount: hospitals.length,
                );
              },
              failure: (error, stackTrace) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Error Getting Hospitals'),
                    const SizedBox(height: 20),
                    Text(error),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<ListHospitalsBloc>()
                            .add(const ListHospitalsEvent.started());
                      },
                      child: const Text('Try Again'),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
```

### GetHospital feature

For the GetHospitalFeature, the server will receive the `hospital_id` via `GetHospitalRequest` and return a `Hospital`. 

Let's create the feature using `flutter_bloc_feature` brick. 

```bash
mason make flutter_bloc_feature --name get_hospital --type bloc --style freezed
```
After that, let's go into the `lib/get_hospital/bloc/get_hospital_event.dart` file and customize our event to take the `required String id` parameter which will represent the id of the hospital we want to fetch. 

```dart

part of 'get_hospital_bloc.dart';

@freezed
class GetHospitalEvent with _$GetHospitalEvent {
  const factory GetHospitalEvent.started({
    required String id,
  }) = _Started;
}

```
In terms of the states we want to handle, we'll have a similar situation with `ListHospitalFeature` but add a state for when the hospital is notFound. 

```dart
part of 'get_hospital_bloc.dart';

@freezed
class GetHospitalState with _$GetHospitalState {
  const factory GetHospitalState.initial() = _Initial;
  const factory GetHospitalState.loading(String message) = _Loading;
  const factory GetHospitalState.loaded({
    required Hospital hospital,
  }) = _Loaded;
  const factory GetHospitalState.notFound({
    required String message,
  }) = _NotFound;
  const factory GetHospitalState.failure({
    required String error,
    StackTrace? stackTrace,
  }) = _Failure;
}
```


In the BLOC, it's also a bit straight foward. We're going to make the request to the server and handle the `notFound` exception when the requests terminates with a Grpc exception. 

```dart
import 'package:african_hospitals_client/african_hospitals_client.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grpc/grpc.dart';

part 'get_hospital_event.dart';
part 'get_hospital_state.dart';
part 'get_hospital_bloc.freezed.dart';

class GetHospitalBloc extends Bloc<GetHospitalEvent, GetHospitalState> {
  GetHospitalBloc({
    required this.hospitalServiceClient,
  }) : super(const GetHospitalState.initial()) {
    on<GetHospitalEvent>((event, emit) async {
      await event.when(started: (hospitalId) async {
        try {
          emit(GetHospitalState.loading('Getting hospital: $hospitalId'));
          final response = await hospitalServiceClient.getHospital(
            GetHospitalRequest(
              id: hospitalId,
            ),
          );
          emit(GetHospitalState.loaded(hospital: response));
        } on GrpcError catch (e, st) {
          if (e.code == StatusCode.notFound) {
            emit(
              GetHospitalState.notFound(
                message: 'Hospital with id: $hospitalId not found',
              ),
            );
          } else {
            emit(
              GetHospitalState.failure(
                error: e.toString(),
                stackTrace: st,
              ),
            );
          }
        }
      });
    });
  }

  final HospitalServiceClient hospitalServiceClient;
}
```

As you can see, in the try-catch section, when request completes successfully, we render change the state to loaded, and when a `GrpcError` occurs, we check if the error statusCode is `notFound` and change the state to notFound. Otherwise, we handle any other exception as a failure. 

In our UI, we want such that when someone clicks on a Hospital in the ListHospitals feature ListView, we'll add the event to our BLOC and push the user to the GetHospitalsPage. This means our BLOC will need to be accessible before the GetHospitalsPage is created. 

We'll refactor our app and move all BLOCS to the main entrypoint and use `MultiBlocProvider` to inject all instances of the BLOCs to our widget tree. 

Our main app looked something like this 
```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final client = AfricanHospitalsClient.client(
      host: 'localhost',
      isSecure: false,
      port: 9980,
      interceptors: [],
    );
    return RepositoryProvider<HospitalServiceClient>(
      create: (context) => client,
      child: MaterialApp(
        title: 'Flutter gRPC Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const ListHospitalsPage(),
      ),
    );
  }
}
```
but we'll now change it to have the MultiBlocProvider.
The resulting change will look like this.

```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final client = AfricanHospitalsClient.client(
      host: 'localhost',
      isSecure: false,
      port: 9980,
      interceptors: [],
    );
    return RepositoryProvider<HospitalServiceClient>(
      create: (context) => client,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ListHospitalsBloc(
              hospitalServiceClient: context.read<HospitalServiceClient>(),
            ),
          ),
          BlocProvider(
            create: (context) => GetHospitalBloc(
              hospitalServiceClient: context.read<HospitalServiceClient>(),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Flutter gRPC Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const ListHospitalsPage(),
        ),
      ),
    );
  }
}
```

Now in the `ListHospitalsPage` widget, since we we're adding the event to start loading of the hostpitals when creating the BLOC, we'll need to change the widget to be stateful so that we can add the event in the `initState` once the widget is rendered. 
The resulting `ListHospitalsPage` will look like this
```dart
class ListHospitalsPage extends StatefulWidget {
  const ListHospitalsPage({super.key});

  @override
  State<ListHospitalsPage> createState() => _ListHospitalsPageState();
}

class _ListHospitalsPageState extends State<ListHospitalsPage> {
  @override
  void initState() {
    // new change
    context.read<ListHospitalsBloc>().add(const ListHospitalsEvent.started());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const ListHospitalsView();
  }
}
```

To test the GetHospitalFeature, when someone clicks on the ListHospitalsPage ListTile, we'll push the user to GetHospitalsPage, and add the event to the GetHospitalsBloc. 

The updated builder when the ListHospitalsState is loaded looks like 
```dart
...
loaded: (hospitals) {
  return ListView.builder(
    itemBuilder: (context, index) {
      final hospital = hospitals[index];
      return ListTile(
        title: Text(hospital.name),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => GetHospitalPage(id: hospital.id),
            ),
          );
          context
              .read<GetHospitalBloc>()
              .add(GetHospitalEvent.started(id: hospital.id));
        },
      );
    },
    itemCount: hospitals.length,
  );
},
```
