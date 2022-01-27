// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: camel_case_types

import 'dart:typed_data';

import 'package:objectbox/flatbuffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart';
import 'package:objectbox_flutter_libs/objectbox_flutter_libs.dart';

import 'dbModels/routine_entry_model.dart';
import 'dbModels/session_entry_model.dart';
import 'dbModels/session_item_model.dart';
import 'dbModels/set_item_model.dart';
import 'dbModels/workout_entry_model.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <ModelEntity>[
  ModelEntity(
      id: const IdUid(3, 6349373929477905858),
      name: 'SetItem',
      lastPropertyId: const IdUid(3, 7566590590164589054),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 8308774796900781441),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 8345639757594749507),
            name: 'metricValue',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 7566590590164589054),
            name: 'countValue',
            type: 6,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(4, 3781393106579796184),
      name: 'WorkoutEntry',
      lastPropertyId: const IdUid(13, 6779438891228135064),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 1789044328783338726),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(3, 5136492222937364875),
            name: 'description',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 3802314350490831935),
            name: 'caption',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 8660973223122060033),
            name: 'prevSessionId',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 8664091358710413773),
            name: 'metric',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(9, 1620244117553902582),
            name: 'type',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(12, 497259292331835192),
            name: 'partList',
            type: 30,
            flags: 0),
        ModelProperty(
            id: const IdUid(13, 6779438891228135064),
            name: 'visible',
            type: 1,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(5, 2106140805026109026),
      name: 'SessionItem',
      lastPropertyId: const IdUid(3, 5909040904623200500),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 2565150483499850926),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 2207648410912630680),
            name: 'time',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 5909040904623200500),
            name: 'workoutId',
            type: 6,
            flags: 0)
      ],
      relations: <ModelRelation>[
        ModelRelation(
            id: const IdUid(1, 7177883577583130157),
            name: 'sets',
            targetId: const IdUid(3, 6349373929477905858))
      ],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(6, 2659339368501590805),
      name: 'RoutineEntry',
      lastPropertyId: const IdUid(5, 7150817849369153182),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 5832932175597938606),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 492210282316528568),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 4758389869014186524),
            name: 'description',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 3781991211420081365),
            name: 'parts',
            type: 30,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 7150817849369153182),
            name: 'workoutIds',
            type: 30,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(7, 2171192922638435355),
      name: 'SessionEntry',
      lastPropertyId: const IdUid(9, 7654838627970482244),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 5447014554903886093),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 231930449571725323),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 438261092846660014),
            name: 'parts',
            type: 30,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 5044386775413530531),
            name: 'startTime',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 224209938074847016),
            name: 'endTime',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 8786175473996993021),
            name: 'year',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 7980500890277537629),
            name: 'month',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 8374476757382434919),
            name: 'description',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(9, 7654838627970482244),
            name: 'day',
            type: 6,
            flags: 0)
      ],
      relations: <ModelRelation>[
        ModelRelation(
            id: const IdUid(3, 6874298313129767344),
            name: 'sets',
            targetId: const IdUid(5, 2106140805026109026))
      ],
      backlinks: <ModelBacklink>[])
];

/// Open an ObjectBox store with the model declared in this file.
Future<Store> openStore(
        {String? directory,
        int? maxDBSizeInKB,
        int? fileMode,
        int? maxReaders,
        bool queriesCaseSensitiveDefault = true,
        String? macosApplicationGroup}) async =>
    Store(getObjectBoxModel(),
        directory: directory ?? (await defaultStoreDirectory()).path,
        maxDBSizeInKB: maxDBSizeInKB,
        fileMode: fileMode,
        maxReaders: maxReaders,
        queriesCaseSensitiveDefault: queriesCaseSensitiveDefault,
        macosApplicationGroup: macosApplicationGroup);

/// ObjectBox model definition, pass it to [Store] - Store(getObjectBoxModel())
ModelDefinition getObjectBoxModel() {
  final model = ModelInfo(
      entities: _entities,
      lastEntityId: const IdUid(7, 2171192922638435355),
      lastIndexId: const IdUid(2, 1332689487264034509),
      lastRelationId: const IdUid(3, 6874298313129767344),
      lastSequenceId: const IdUid(0, 0),
      retiredEntityUids: const [3737160477377805400, 3214364996229660332],
      retiredIndexUids: const [7135608505005199690, 1332689487264034509],
      retiredPropertyUids: const [
        6987834240152858428,
        8166532937300263511,
        4299233684867096687,
        8937478955789243757,
        404051633199124960,
        151218328208462529,
        6122815529505620157,
        3678274702609055183,
        118894163494458036,
        596407192099789693
      ],
      retiredRelationUids: const [2888247885336091349],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, EntityDefinition>{
    SetItem: EntityDefinition<SetItem>(
        model: _entities[0],
        toOneRelations: (SetItem object) => [],
        toManyRelations: (SetItem object) => {},
        getId: (SetItem object) => object.id,
        setId: (SetItem object, int id) {
          object.id = id;
        },
        objectToFB: (SetItem object, fb.Builder fbb) {
          fbb.startTable(4);
          fbb.addInt64(0, object.id);
          fbb.addInt64(1, object.metricValue);
          fbb.addInt64(2, object.countValue);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = SetItem(
              metricValue:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 6, 0),
              countValue:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 8, 0))
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);

          return object;
        }),
    WorkoutEntry: EntityDefinition<WorkoutEntry>(
        model: _entities[1],
        toOneRelations: (WorkoutEntry object) => [],
        toManyRelations: (WorkoutEntry object) => {},
        getId: (WorkoutEntry object) => object.id,
        setId: (WorkoutEntry object, int id) {
          object.id = id;
        },
        objectToFB: (WorkoutEntry object, fb.Builder fbb) {
          final descriptionOffset = fbb.writeString(object.description);
          final captionOffset = fbb.writeString(object.caption);
          final metricOffset = fbb.writeString(object.metric);
          final typeOffset = fbb.writeString(object.type);
          final partListOffset = fbb.writeList(
              object.partList.map(fbb.writeString).toList(growable: false));
          fbb.startTable(14);
          fbb.addInt64(0, object.id);
          fbb.addOffset(2, descriptionOffset);
          fbb.addOffset(5, captionOffset);
          fbb.addInt64(6, object.prevSessionId);
          fbb.addOffset(7, metricOffset);
          fbb.addOffset(8, typeOffset);
          fbb.addOffset(11, partListOffset);
          fbb.addBool(12, object.visible);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = WorkoutEntry()
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0)
            ..description =
                const fb.StringReader().vTableGet(buffer, rootOffset, 8, '')
            ..caption =
                const fb.StringReader().vTableGet(buffer, rootOffset, 14, '')
            ..prevSessionId =
                const fb.Int64Reader().vTableGet(buffer, rootOffset, 16, 0)
            ..metric =
                const fb.StringReader().vTableGet(buffer, rootOffset, 18, '')
            ..type =
                const fb.StringReader().vTableGet(buffer, rootOffset, 20, '')
            ..partList =
                const fb.ListReader<String>(fb.StringReader(), lazy: false)
                    .vTableGet(buffer, rootOffset, 26, [])
            ..visible =
                const fb.BoolReader().vTableGet(buffer, rootOffset, 28, false);

          return object;
        }),
    SessionItem: EntityDefinition<SessionItem>(
        model: _entities[2],
        toOneRelations: (SessionItem object) => [],
        toManyRelations: (SessionItem object) =>
            {RelInfo<SessionItem>.toMany(1, object.id): object.sets},
        getId: (SessionItem object) => object.id,
        setId: (SessionItem object, int id) {
          object.id = id;
        },
        objectToFB: (SessionItem object, fb.Builder fbb) {
          fbb.startTable(4);
          fbb.addInt64(0, object.id);
          fbb.addInt64(1, object.time);
          fbb.addInt64(2, object.workoutId);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = SessionItem()
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0)
            ..time = const fb.Int64Reader().vTableGet(buffer, rootOffset, 6, 0)
            ..workoutId =
                const fb.Int64Reader().vTableGet(buffer, rootOffset, 8, 0);
          InternalToManyAccess.setRelInfo(
              object.sets,
              store,
              RelInfo<SessionItem>.toMany(1, object.id),
              store.box<SessionItem>());
          return object;
        }),
    RoutineEntry: EntityDefinition<RoutineEntry>(
        model: _entities[3],
        toOneRelations: (RoutineEntry object) => [],
        toManyRelations: (RoutineEntry object) => {},
        getId: (RoutineEntry object) => object.id,
        setId: (RoutineEntry object, int id) {
          object.id = id;
        },
        objectToFB: (RoutineEntry object, fb.Builder fbb) {
          final nameOffset = fbb.writeString(object.name);
          final descriptionOffset = fbb.writeString(object.description);
          final partsOffset = fbb.writeList(
              object.parts.map(fbb.writeString).toList(growable: false));
          final workoutIdsOffset = fbb.writeList(
              object.workoutIds.map(fbb.writeString).toList(growable: false));
          fbb.startTable(6);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, nameOffset);
          fbb.addOffset(2, descriptionOffset);
          fbb.addOffset(3, partsOffset);
          fbb.addOffset(4, workoutIdsOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = RoutineEntry()
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0)
            ..name =
                const fb.StringReader().vTableGet(buffer, rootOffset, 6, '')
            ..description =
                const fb.StringReader().vTableGet(buffer, rootOffset, 8, '')
            ..parts =
                const fb.ListReader<String>(fb.StringReader(), lazy: false)
                    .vTableGet(buffer, rootOffset, 10, [])
            ..workoutIds =
                const fb.ListReader<String>(fb.StringReader(), lazy: false)
                    .vTableGet(buffer, rootOffset, 12, []);

          return object;
        }),
    SessionEntry: EntityDefinition<SessionEntry>(
        model: _entities[4],
        toOneRelations: (SessionEntry object) => [],
        toManyRelations: (SessionEntry object) =>
            {RelInfo<SessionEntry>.toMany(3, object.id): object.sets},
        getId: (SessionEntry object) => object.id,
        setId: (SessionEntry object, int id) {
          object.id = id;
        },
        objectToFB: (SessionEntry object, fb.Builder fbb) {
          final nameOffset = fbb.writeString(object.name);
          final partsOffset = fbb.writeList(
              object.parts.map(fbb.writeString).toList(growable: false));
          final descriptionOffset = fbb.writeString(object.description);
          fbb.startTable(10);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, nameOffset);
          fbb.addOffset(2, partsOffset);
          fbb.addInt64(3, object.startTime);
          fbb.addInt64(4, object.endTime);
          fbb.addInt64(5, object.year);
          fbb.addInt64(6, object.month);
          fbb.addOffset(7, descriptionOffset);
          fbb.addInt64(8, object.day);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = SessionEntry()
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0)
            ..name =
                const fb.StringReader().vTableGet(buffer, rootOffset, 6, '')
            ..parts =
                const fb.ListReader<String>(fb.StringReader(), lazy: false)
                    .vTableGet(buffer, rootOffset, 8, [])
            ..startTime =
                const fb.Int64Reader().vTableGet(buffer, rootOffset, 10, 0)
            ..endTime =
                const fb.Int64Reader().vTableGet(buffer, rootOffset, 12, 0)
            ..year = const fb.Int64Reader().vTableGet(buffer, rootOffset, 14, 0)
            ..month =
                const fb.Int64Reader().vTableGet(buffer, rootOffset, 16, 0)
            ..description =
                const fb.StringReader().vTableGet(buffer, rootOffset, 18, '')
            ..day = const fb.Int64Reader().vTableGet(buffer, rootOffset, 20, 0);
          InternalToManyAccess.setRelInfo(
              object.sets,
              store,
              RelInfo<SessionEntry>.toMany(3, object.id),
              store.box<SessionEntry>());
          return object;
        })
  };

  return ModelDefinition(model, bindings);
}

/// [SetItem] entity fields to define ObjectBox queries.
class SetItem_ {
  /// see [SetItem.id]
  static final id = QueryIntegerProperty<SetItem>(_entities[0].properties[0]);

  /// see [SetItem.metricValue]
  static final metricValue =
      QueryIntegerProperty<SetItem>(_entities[0].properties[1]);

  /// see [SetItem.countValue]
  static final countValue =
      QueryIntegerProperty<SetItem>(_entities[0].properties[2]);
}

/// [WorkoutEntry] entity fields to define ObjectBox queries.
class WorkoutEntry_ {
  /// see [WorkoutEntry.id]
  static final id =
      QueryIntegerProperty<WorkoutEntry>(_entities[1].properties[0]);

  /// see [WorkoutEntry.description]
  static final description =
      QueryStringProperty<WorkoutEntry>(_entities[1].properties[1]);

  /// see [WorkoutEntry.caption]
  static final caption =
      QueryStringProperty<WorkoutEntry>(_entities[1].properties[2]);

  /// see [WorkoutEntry.prevSessionId]
  static final prevSessionId =
      QueryIntegerProperty<WorkoutEntry>(_entities[1].properties[3]);

  /// see [WorkoutEntry.metric]
  static final metric =
      QueryStringProperty<WorkoutEntry>(_entities[1].properties[4]);

  /// see [WorkoutEntry.type]
  static final type =
      QueryStringProperty<WorkoutEntry>(_entities[1].properties[5]);

  /// see [WorkoutEntry.partList]
  static final partList =
      QueryStringVectorProperty<WorkoutEntry>(_entities[1].properties[6]);

  /// see [WorkoutEntry.visible]
  static final visible =
      QueryBooleanProperty<WorkoutEntry>(_entities[1].properties[7]);
}

/// [SessionItem] entity fields to define ObjectBox queries.
class SessionItem_ {
  /// see [SessionItem.id]
  static final id =
      QueryIntegerProperty<SessionItem>(_entities[2].properties[0]);

  /// see [SessionItem.time]
  static final time =
      QueryIntegerProperty<SessionItem>(_entities[2].properties[1]);

  /// see [SessionItem.workoutId]
  static final workoutId =
      QueryIntegerProperty<SessionItem>(_entities[2].properties[2]);

  /// see [SessionItem.sets]
  static final sets =
      QueryRelationToMany<SessionItem, SetItem>(_entities[2].relations[0]);
}

/// [RoutineEntry] entity fields to define ObjectBox queries.
class RoutineEntry_ {
  /// see [RoutineEntry.id]
  static final id =
      QueryIntegerProperty<RoutineEntry>(_entities[3].properties[0]);

  /// see [RoutineEntry.name]
  static final name =
      QueryStringProperty<RoutineEntry>(_entities[3].properties[1]);

  /// see [RoutineEntry.description]
  static final description =
      QueryStringProperty<RoutineEntry>(_entities[3].properties[2]);

  /// see [RoutineEntry.parts]
  static final parts =
      QueryStringVectorProperty<RoutineEntry>(_entities[3].properties[3]);

  /// see [RoutineEntry.workoutIds]
  static final workoutIds =
      QueryStringVectorProperty<RoutineEntry>(_entities[3].properties[4]);
}

/// [SessionEntry] entity fields to define ObjectBox queries.
class SessionEntry_ {
  /// see [SessionEntry.id]
  static final id =
      QueryIntegerProperty<SessionEntry>(_entities[4].properties[0]);

  /// see [SessionEntry.name]
  static final name =
      QueryStringProperty<SessionEntry>(_entities[4].properties[1]);

  /// see [SessionEntry.parts]
  static final parts =
      QueryStringVectorProperty<SessionEntry>(_entities[4].properties[2]);

  /// see [SessionEntry.startTime]
  static final startTime =
      QueryIntegerProperty<SessionEntry>(_entities[4].properties[3]);

  /// see [SessionEntry.endTime]
  static final endTime =
      QueryIntegerProperty<SessionEntry>(_entities[4].properties[4]);

  /// see [SessionEntry.year]
  static final year =
      QueryIntegerProperty<SessionEntry>(_entities[4].properties[5]);

  /// see [SessionEntry.month]
  static final month =
      QueryIntegerProperty<SessionEntry>(_entities[4].properties[6]);

  /// see [SessionEntry.description]
  static final description =
      QueryStringProperty<SessionEntry>(_entities[4].properties[7]);

  /// see [SessionEntry.day]
  static final day =
      QueryIntegerProperty<SessionEntry>(_entities[4].properties[8]);

  /// see [SessionEntry.sets]
  static final sets =
      QueryRelationToMany<SessionEntry, SessionItem>(_entities[4].relations[0]);
}
