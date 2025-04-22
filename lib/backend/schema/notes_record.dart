import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class NotesRecord extends FirestoreRecord {
  NotesRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "color" field.
  Color? _color;
  Color? get color => _color;
  bool hasColor() => _color != null;

  // "pinned" field.
  bool? _pinned;
  bool get pinned => _pinned ?? false;
  bool hasPinned() => _pinned != null;

  // "favorited" field.
  bool? _favorited;
  bool get favorited => _favorited ?? false;
  bool hasFavorited() => _favorited != null;

  // "deleted" field.
  bool? _deleted;
  bool get deleted => _deleted ?? false;
  bool hasDeleted() => _deleted != null;

  // "createTime" field.
  DateTime? _createTime;
  DateTime? get createTime => _createTime;
  bool hasCreateTime() => _createTime != null;

  // "lastEditTime" field.
  DateTime? _lastEditTime;
  DateTime? get lastEditTime => _lastEditTime;
  bool hasLastEditTime() => _lastEditTime != null;

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  bool hasTitle() => _title != null;

  // "content" field.
  String? _content;
  String get content => _content ?? '';
  bool hasContent() => _content != null;

  // "owner" field.
  String? _owner;
  String get owner => _owner ?? '';
  bool hasOwner() => _owner != null;

  // "image" field.
  String? _image;
  String get image => _image ?? '';
  bool hasImage() => _image != null;

  void _initializeFields() {
    _color = getSchemaColor(snapshotData['color']);
    _pinned = snapshotData['pinned'] as bool?;
    _favorited = snapshotData['favorited'] as bool?;
    _deleted = snapshotData['deleted'] as bool?;
    _createTime = snapshotData['createTime'] as DateTime?;
    _lastEditTime = snapshotData['lastEditTime'] as DateTime?;
    _title = snapshotData['title'] as String?;
    _content = snapshotData['content'] as String?;
    _owner = snapshotData['owner'] as String?;
    _image = snapshotData['image'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('notes');

  static Stream<NotesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => NotesRecord.fromSnapshot(s));

  static Future<NotesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => NotesRecord.fromSnapshot(s));

  static NotesRecord fromSnapshot(DocumentSnapshot snapshot) => NotesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static NotesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      NotesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'NotesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is NotesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createNotesRecordData({
  Color? color,
  bool? pinned,
  bool? favorited,
  bool? deleted,
  DateTime? createTime,
  DateTime? lastEditTime,
  String? title,
  String? content,
  String? owner,
  String? image,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'color': color,
      'pinned': pinned,
      'favorited': favorited,
      'deleted': deleted,
      'createTime': createTime,
      'lastEditTime': lastEditTime,
      'title': title,
      'content': content,
      'owner': owner,
      'image': image,
    }.withoutNulls,
  );

  return firestoreData;
}

class NotesRecordDocumentEquality implements Equality<NotesRecord> {
  const NotesRecordDocumentEquality();

  @override
  bool equals(NotesRecord? e1, NotesRecord? e2) {
    return e1?.color == e2?.color &&
        e1?.pinned == e2?.pinned &&
        e1?.favorited == e2?.favorited &&
        e1?.deleted == e2?.deleted &&
        e1?.createTime == e2?.createTime &&
        e1?.lastEditTime == e2?.lastEditTime &&
        e1?.title == e2?.title &&
        e1?.content == e2?.content &&
        e1?.owner == e2?.owner &&
        e1?.image == e2?.image;
  }

  @override
  int hash(NotesRecord? e) => const ListEquality().hash([
        e?.color,
        e?.pinned,
        e?.favorited,
        e?.deleted,
        e?.createTime,
        e?.lastEditTime,
        e?.title,
        e?.content,
        e?.owner,
        e?.image
      ]);

  @override
  bool isValidKey(Object? o) => o is NotesRecord;
}
