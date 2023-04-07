---
sidebar_position: 2
description: Creating a Flutter Client using Riverpod.
---

# Flutter Client using Riverpod.

In this guide, we'll use freezed, riverpod,flutter and [mason](https://pub.dev/packages/mason_cli) for code generation.

Mason is a code generator for Dart and any projects. It generates code based on templates that are defined. These templates are available on [BrickHub](https://brickhub.dev/). Since we'll be using the feature folder style, we have a Mason brick/template that will assist with that. 

We'll use [feature_brick](https://brickhub.dev/bricks/feature_brick/0.6.1) to assist us in easily generating the folder structure using the feature structure so that we can implement the functionality with ease. 

## Getting Started

We'll create a Flutter application using the command `flutter create african_hospitals_riverpod_client`.

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

## TODO
- [ ] ListHospitals
- [ ] GetHospital functionality
- [ ] SearchHospitals functionality. 

## Riverpod
Riverpod is the rewrite of provider but better in every way. Riverpod enables you to control the application logic using providers which are elements that hold and control the logic of your application. 
Riverpod comes with it's own set of providers that enable us to handle tasks like watching a future, streams, changing values etc through it's available set of providers.
## Available Providers 
- FutureProvider - this is used to watch asynchronous value changes. For many IO related tasks, at one point there can be Loading,Loaded or Completion with an Error. FutureProvider handles this automatically for you. 
- StreamProvider - Streams are things that continually emit data. Things like websockets, changes from an input field/location data etc. This enables us to watch for changes in a stream and update the value in the UI. 
- StateNotifierProvider - This enables us to expose a `StateNotifier` which is a class which enables finer grained control of the program logic. `StateNotifier` classes typically expose methods which when called, do some work and change the state in any manner the developer wants. 
- StateProvider - This is primarily to allow the modification of simple variables by the User Interface. e.g activeFilters, currentlySelectedIndex etc. 
- Provider - This is used to provide things that don't really change in our application. It can be used for dependency injection. i.e Providing the AfricanHospitalsClient so that other providers can access it's value. It's helpful in testing as well as this value can be overriden for a specific scope. So you can override the provided value with a mock. 
To learn more about these, you can head to https://riverpod.dev and check the available providers on the `All Providers` section.

In this guide, we'll use Provider, FutureProvider, StreamProvider and maybe StateNotifierProvider.

## Add Required Dependencies
We'll need the following dependencies:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.1.3
  riverpod_annotation: ^1.1.1
  african_hospitals_client: 
    path: ../../african_hospitals_client
  grpc: ^3.1.0

  # The following adds the Cupertino Icons font to your application.
  # Use with the CupertinoIcons class for iOS style icons.
  cupertino_icons: ^1.0.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner:
  riverpod_generator: ^1.1.1
```

Once our dependencies are installed, we can proceed to implement the features. 

# AfricanHospitalsClient provider
This will be used by to provide the `HospitalServiceClient` to other providers and the UI if need be. 
Let's create a file under lib called `lib/african_hospitals_client_provider.dart`

```dart title=lib/african_hospitals_client_provider.dart
import 'package:african_hospitals_client/african_hospitals_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final hospitalsServiceClientProvider = Provider(
  (ref) => AfricanHospitalsClient.client(
    host: '10.0.2.2',
    isSecure: false,
    port: 9980,
    interceptors: [],
  ),
);
```


# ListHospitals
Since the ListHospitals function is a simple onetime future call, we'll use a FutureProvider to provide the future. 

Let's implement this feature. We'll use the feature_brick to create the folder structure and directory. 
```bash
mason make feature_brick --feature_name list_hospitals --state_management riverpod
```
You'll see the following files created in `lib/`
```bash
✓ Generated 6 files. (0.2s)
  created list_hospitals/list_hospitals.dart
  created list_hospitals/view/list_hospitals_page.dart
  created list_hospitals/provider/provider.dart
  created list_hospitals/provider/list_hospitals_provider.dart
  created list_hospitals/widgets/widgets.dart
  created list_hospitals/widgets/list_hospitals_body.dart
✓ Tests created! (0.3s)
```

## ListHospitals Provider
You'll see that the following code has been generated when you go to `lib/list_hospitals/provider/list_hospitals_provider.dart`. This is the code that is generated by the feature_brick brick. We'll need to modify this to be a FutureProvider.

```dart
import 'package:riverpod/riverpod.dart';

final listHospitalsProvider = StateNotifierProvider.autoDispose((ref) {
  return ListHospitals();
});

class ListHospitals extends StateNotifier<int> {
  ListHospitals() : super(0);

  void increment() => state++;
  void decrement() => state--;
}
```
To implement this, we'll need to get the `HospitalServiceClient` instance from the hospitalsServiceClientProvider and make the call to the server. 

```dart
import 'package:african_hospitals_client/african_hospitals_client.dart';
import 'package:african_hospitals_riverpod_client/african_hospitals_client_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final listHospitalsProvider = FutureProvider<List<Hospital>>((ref) {
  final hospitalsServiceClient = ref.read(hospitalsServiceClientProvider);
  return hospitalsServiceClient
      .listHospitals(ListHospitalsRequest())
      .then((response) => response.hospitals);
});
```
As you can see, we use the `ref.read` functionality to read a non-changing variable and then call the `listHospitals` method. Once it completes, we take the hospitals list from returned `ListHospitalsResponse` object. 

## ListHospitals UI
To implement the UI, we're going to use `ref.watch` to keep watching for changes in the value of the future and update the UI based on it. Riverpod comes with an `AsyncValue` which enables us to transform the value of the future functionally the way `freezed` union types work. When you watch a FutureProvider, you get an `AsyncValue` object which is a union of three states. [Loading, Loaded or CompletionWithAnError]. We can functionally transform the `AsyncValue` into Widgets to be rendered in our application. 

As an example, in our case this will be. 
```dart
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(listHospitalsProvider);
    return state.when(
      data: (hospitals) => HospitalsListView(hospitals: hospitals),
      error: (error, stackTrace) => ErrorWidget(error),
      loading: () => LoadingIndicator(),
    );
  }
```
This is equivalent to saying 
1. When the state is Loading, show `LoadingIndicator` widget. 
2. When the state is CompletedWithError, show the `ErrorWidget`.
3. When the state is Loaded/Success, render our `HospitalsListView` widget.

The complete version will be 
```dart 
class ListHospitalsBody extends ConsumerWidget {
  /// {@macro list_hospitals_body}
  const ListHospitalsBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(listHospitalsProvider);
    return state.when(
      data: (hospitals) {
        return ListView.builder(
          itemBuilder: (context, index) {
            final hospital = hospitals[index];
            return ListTile(
              title: Text(hospital.name),
              onTap: () {},
            );
          },
          itemCount: hospitals.length,
        );
      },
      error: (error, stackTrace) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Error Getting Hospitals'),
            const SizedBox(height: 20),
            Text(error.toString()),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ref.invalidate(listHospitalsProvider);
              },
              child: const Text('Try Again'),
            ),
          ],
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }
}
```
Also pay attention to how we use the `ref.invalidate(listHospitalsProvider)` to try again in case of an error. 

# GetHospital 
This will also be a simple future call to get hospitals. The trick with this is that we'll need to pass the hospital id to the FutureProvider.
This is where `FutureProviderFamily` comes in. It's a FutureProvider which can be used in cases where you want to get a Future for a specific value. 

Imagine you have a list of `Post` model called `Post` which has the `user_id` of the author. Say you'll want to load the `Author` model as soon as the Post is rendered on your UI. This is where the `FutureProviderFamily` will be used. 


## Create the folder structure
```bash
mason make feature_brick --feature_name get_hospital --state_management riverpod

✓ Generated 6 files. (0.2s)
  created get_hospital/get_hospital.dart
  created get_hospital/view/get_hospital_page.dart
  created get_hospital/provider/provider.dart
  created get_hospital/provider/get_hospital_provider.dart
  created get_hospital/widgets/widgets.dart
  created get_hospital/widgets/get_hospital_body.dart
✓ Tests created! (0.4s)
```

Let's get into the `lib/get_hospital/provider/get_hospital_provider.dart` file and modify it to our liking.

## GetHospital Provider

```dart title=lib/get_hospital/provider/get_hospital_provider.dart
import 'package:african_hospitals_client/african_hospitals_client.dart';
import 'package:african_hospitals_riverpod_client/african_hospitals_client_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grpc/grpc.dart';

final getHospitalProvider = FutureProviderFamily((ref, String id) {
  final hospitalServiceClient = ref.read(hospitalsServiceClientProvider);
  try {
    return hospitalServiceClient.getHospital(GetHospitalRequest(id: id));
  } on GrpcError catch (e) {
    if (e.code == StatusCode.notFound) {
      return null;
    }
    rethrow;
  }
});
```
As you can see, the difference between FutureProvider and FutureProviderFamily is the extra parameter which will be specified by the UI when accessing the provider. 
When the Future is complete, we'll have either a nullable Hospital object or an error. 

## GetHospital UI
In order to access the provider from our UI, we'll need the hospital id. We'll modify the `GetHospitalBody` and `GetHospitalPage` to be able to pass the `id` of the hospital we want to view. 

```dart
class GetHospitalBody extends ConsumerWidget {
  /// {@macro get_hospital_body}
  const GetHospitalBody({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(getHospitalProvider(id));
    return state.when(
      data: (hospital) {
        if (hospital == null) {
          return Center(
            child: Text('Hospital $id not found'),
          );
        } else {
          return Center(child: Text(hospital.toString()));
        }
      },
      error: (error, stackTrace) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Error Getting Hospitals'),
            const SizedBox(height: 20),
            Text(error.toString()),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ref.invalidate(getHospitalProvider(id));
              },
              child: const Text('Try Again'),
            ),
          ],
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }
}
```

As you can see to access the state of our future, we still have to use `ref.watch` but we're building the provider with an `id` of the hospital like 
```dart
final state = ref.watch(getHospitalProvider(id));
```
The returned `state` value will be an `AsyncValue` and we can transform or map it to widgets to be displayed in our UI. 

## SearchHospitals
In this section, we'll want that as the user is typing, we take the value being typed and send the request to our server then render the list which was returned by the server, like an autocomplete. 
In an ideal world, we can use bi-directional streaming since the user on our side is sending changing data, and the server could also respond with changing data as well. This would be really nice since once the stream socket is opened, there would be reduced latency. 

The problem is on web, grpc doesn't currently support bi-directional streaming. It only supports server-side streaming which is where the server continually sends data to the client the way websockets do work. 

# TODO
- [ ] Check whether to use a bi-directional stream or unary calls.