import 'package:stormberry/stormberry.dart';

part 'user.schema.dart';

@Model(views: [#Complete, #Reduced])
abstract class User {
  @PrimaryKey()
  String get id;

  @HiddenIn(#Reduced)
  String get email;

  String? get name;

  @HiddenIn(#Reduced)
  @ViewedIn(#Complete, as: #Base)
  List<Video> get videos;
}

@Model(views: [#Base, #Info])
abstract class Video {
  @PrimaryKey()
  String get id;

  String get title;

  DateTime get createdAt;

  String get url;

  @ViewedIn(#Base, as: #Reduced)
  @ViewedIn(#Info, as: #Reduced)
  User get creator;
}

// Read all classes with their properties
// Generate proto messages from the classes
// Generate CRUD protos for every proto message
// Generate extension methods for fromGrpc() and toGrpc()
