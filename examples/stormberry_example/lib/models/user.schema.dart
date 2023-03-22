part of 'user.dart';

extension UserRepositories on Database {
  UserRepository get users => UserRepository._(this);
  VideoRepository get videos => VideoRepository._(this);
}

abstract class UserRepository
    implements
        ModelRepository,
        ModelRepositoryInsert<UserInsertRequest>,
        ModelRepositoryUpdate<UserUpdateRequest>,
        ModelRepositoryDelete<String> {
  factory UserRepository._(Database db) = _UserRepository;

  Future<CompleteUserView?> queryCompleteView(String id);
  Future<List<CompleteUserView>> queryCompleteViews([QueryParams? params]);
  Future<ReducedUserView?> queryReducedView(String id);
  Future<List<ReducedUserView>> queryReducedViews([QueryParams? params]);
}

class _UserRepository extends BaseRepository
    with
        RepositoryInsertMixin<UserInsertRequest>,
        RepositoryUpdateMixin<UserUpdateRequest>,
        RepositoryDeleteMixin<String>
    implements UserRepository {
  _UserRepository(super.db) : super(tableName: 'users', keyName: 'id');

  @override
  Future<CompleteUserView?> queryCompleteView(String id) {
    return queryOne(id, CompleteUserViewQueryable());
  }

  @override
  Future<List<CompleteUserView>> queryCompleteViews([QueryParams? params]) {
    return queryMany(CompleteUserViewQueryable(), params);
  }

  @override
  Future<ReducedUserView?> queryReducedView(String id) {
    return queryOne(id, ReducedUserViewQueryable());
  }

  @override
  Future<List<ReducedUserView>> queryReducedViews([QueryParams? params]) {
    return queryMany(ReducedUserViewQueryable(), params);
  }

  @override
  Future<void> insert(List<UserInsertRequest> requests) async {
    if (requests.isEmpty) return;
    var values = QueryValues();
    await db.query(
      'INSERT INTO "users" ( "id", "email", "name" )\n'
      'VALUES ${requests.map((r) => '( ${values.add(r.id)}:text, ${values.add(r.email)}:text, ${values.add(r.name)}:text )').join(', ')}\n',
      values.values,
    );
  }

  @override
  Future<void> update(List<UserUpdateRequest> requests) async {
    if (requests.isEmpty) return;
    var values = QueryValues();
    await db.query(
      'UPDATE "users"\n'
      'SET "email" = COALESCE(UPDATED."email", "users"."email"), "name" = COALESCE(UPDATED."name", "users"."name")\n'
      'FROM ( VALUES ${requests.map((r) => '( ${values.add(r.id)}:text, ${values.add(r.email)}:text, ${values.add(r.name)}:text )').join(', ')} )\n'
      'AS UPDATED("id", "email", "name")\n'
      'WHERE "users"."id" = UPDATED."id"',
      values.values,
    );
  }
}

abstract class VideoRepository
    implements
        ModelRepository,
        ModelRepositoryInsert<VideoInsertRequest>,
        ModelRepositoryUpdate<VideoUpdateRequest>,
        ModelRepositoryDelete<String> {
  factory VideoRepository._(Database db) = _VideoRepository;

  Future<BaseVideoView?> queryBaseView(String id);
  Future<List<BaseVideoView>> queryBaseViews([QueryParams? params]);
  Future<InfoVideoView?> queryInfoView(String id);
  Future<List<InfoVideoView>> queryInfoViews([QueryParams? params]);
}

class _VideoRepository extends BaseRepository
    with
        RepositoryInsertMixin<VideoInsertRequest>,
        RepositoryUpdateMixin<VideoUpdateRequest>,
        RepositoryDeleteMixin<String>
    implements VideoRepository {
  _VideoRepository(super.db) : super(tableName: 'videos', keyName: 'id');

  @override
  Future<BaseVideoView?> queryBaseView(String id) {
    return queryOne(id, BaseVideoViewQueryable());
  }

  @override
  Future<List<BaseVideoView>> queryBaseViews([QueryParams? params]) {
    return queryMany(BaseVideoViewQueryable(), params);
  }

  @override
  Future<InfoVideoView?> queryInfoView(String id) {
    return queryOne(id, InfoVideoViewQueryable());
  }

  @override
  Future<List<InfoVideoView>> queryInfoViews([QueryParams? params]) {
    return queryMany(InfoVideoViewQueryable(), params);
  }

  @override
  Future<void> insert(List<VideoInsertRequest> requests) async {
    if (requests.isEmpty) return;
    var values = QueryValues();
    await db.query(
      'INSERT INTO "videos" ( "id", "title", "created_at", "url", "creator_id" )\n'
      'VALUES ${requests.map((r) => '( ${values.add(r.id)}:text, ${values.add(r.title)}:text, ${values.add(r.createdAt)}:timestamp, ${values.add(r.url)}:text, ${values.add(r.creatorId)}:text )').join(', ')}\n',
      values.values,
    );
  }

  @override
  Future<void> update(List<VideoUpdateRequest> requests) async {
    if (requests.isEmpty) return;
    var values = QueryValues();
    await db.query(
      'UPDATE "videos"\n'
      'SET "title" = COALESCE(UPDATED."title", "videos"."title"), "created_at" = COALESCE(UPDATED."created_at", "videos"."created_at"), "url" = COALESCE(UPDATED."url", "videos"."url"), "creator_id" = COALESCE(UPDATED."creator_id", "videos"."creator_id")\n'
      'FROM ( VALUES ${requests.map((r) => '( ${values.add(r.id)}:text, ${values.add(r.title)}:text, ${values.add(r.createdAt)}:timestamp, ${values.add(r.url)}:text, ${values.add(r.creatorId)}:text )').join(', ')} )\n'
      'AS UPDATED("id", "title", "created_at", "url", "creator_id")\n'
      'WHERE "videos"."id" = UPDATED."id"',
      values.values,
    );
  }
}

class UserInsertRequest {
  UserInsertRequest({
    required this.id,
    required this.email,
    this.name,
  });

  String id;
  String email;
  String? name;
}

class VideoInsertRequest {
  VideoInsertRequest({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.url,
    required this.creatorId,
  });

  String id;
  String title;
  DateTime createdAt;
  String url;
  String creatorId;
}

class UserUpdateRequest {
  UserUpdateRequest({
    required this.id,
    this.email,
    this.name,
  });

  String id;
  String? email;
  String? name;
}

class VideoUpdateRequest {
  VideoUpdateRequest({
    required this.id,
    this.title,
    this.createdAt,
    this.url,
    this.creatorId,
  });

  String id;
  String? title;
  DateTime? createdAt;
  String? url;
  String? creatorId;
}

class CompleteUserViewQueryable
    extends KeyedViewQueryable<CompleteUserView, String> {
  @override
  String get keyName => 'id';

  @override
  String encodeKey(String key) => TextEncoder.i.encode(key);

  @override
  String get query => 'SELECT "users".*, "videos"."data" as "videos"'
      'FROM "users"'
      'LEFT JOIN ('
      '  SELECT "videos"."creator_id",'
      '    to_jsonb(array_agg("videos".*)) as data'
      '  FROM (${BaseVideoViewQueryable().query}) "videos"'
      '  GROUP BY "videos"."creator_id"'
      ') "videos"'
      'ON "users"."id" = "videos"."creator_id"';

  @override
  String get tableAlias => 'users';

  @override
  CompleteUserView decode(TypedMap map) => CompleteUserView(
      id: map.get('id'),
      email: map.get('email'),
      name: map.getOpt('name'),
      videos: map.getListOpt('videos', BaseVideoViewQueryable().decoder) ??
          const []);
}

class CompleteUserView {
  CompleteUserView({
    required this.id,
    required this.email,
    this.name,
    required this.videos,
  });

  final String id;
  final String email;
  final String? name;
  final List<BaseVideoView> videos;
}

class ReducedUserViewQueryable
    extends KeyedViewQueryable<ReducedUserView, String> {
  @override
  String get keyName => 'id';

  @override
  String encodeKey(String key) => TextEncoder.i.encode(key);

  @override
  String get query => 'SELECT "users".*'
      'FROM "users"';

  @override
  String get tableAlias => 'users';

  @override
  ReducedUserView decode(TypedMap map) =>
      ReducedUserView(id: map.get('id'), name: map.getOpt('name'));
}

class ReducedUserView {
  ReducedUserView({
    required this.id,
    this.name,
  });

  final String id;
  final String? name;
}

class BaseVideoViewQueryable extends KeyedViewQueryable<BaseVideoView, String> {
  @override
  String get keyName => 'id';

  @override
  String encodeKey(String key) => TextEncoder.i.encode(key);

  @override
  String get query => 'SELECT "videos".*, row_to_json("creator".*) as "creator"'
      'FROM "videos"'
      'LEFT JOIN (${ReducedUserViewQueryable().query}) "creator"'
      'ON "videos"."creator_id" = "creator"."id"';

  @override
  String get tableAlias => 'videos';

  @override
  BaseVideoView decode(TypedMap map) => BaseVideoView(
      id: map.get('id'),
      title: map.get('title'),
      createdAt: map.get('created_at'),
      url: map.get('url'),
      creator: map.get('creator', ReducedUserViewQueryable().decoder));
}

class BaseVideoView {
  BaseVideoView({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.url,
    required this.creator,
  });

  final String id;
  final String title;
  final DateTime createdAt;
  final String url;
  final ReducedUserView creator;
}

class InfoVideoViewQueryable extends KeyedViewQueryable<InfoVideoView, String> {
  @override
  String get keyName => 'id';

  @override
  String encodeKey(String key) => TextEncoder.i.encode(key);

  @override
  String get query => 'SELECT "videos".*, row_to_json("creator".*) as "creator"'
      'FROM "videos"'
      'LEFT JOIN (${ReducedUserViewQueryable().query}) "creator"'
      'ON "videos"."creator_id" = "creator"."id"';

  @override
  String get tableAlias => 'videos';

  @override
  InfoVideoView decode(TypedMap map) => InfoVideoView(
      id: map.get('id'),
      title: map.get('title'),
      createdAt: map.get('created_at'),
      url: map.get('url'),
      creator: map.get('creator', ReducedUserViewQueryable().decoder));
}

class InfoVideoView {
  InfoVideoView({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.url,
    required this.creator,
  });

  final String id;
  final String title;
  final DateTime createdAt;
  final String url;
  final ReducedUserView creator;
}
