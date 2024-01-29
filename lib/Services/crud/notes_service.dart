// ignore_for_file: unnecessary_null_comparison

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:registrastionapp/Services/crud/constants.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

import 'crud_exceptions.dart';

// Openning the DataBase
class NoteService {
  Database? db0;

  // Creating a Local list of Notes
  List<DatabaseNote> _notes = [];
  
// Creating a Singleton of Notes Service
  static final NoteService _shared = NoteService._sharedInstance();
  NoteService._sharedInstance();
  factory NoteService() => _shared;

// Creating a Notes Stream Controller
  final _notesStreamController =
      StreamController<List<DatabaseNote>>.broadcast();
// Reading and Caching Notes
  Future<void> _cacheNotes() async {
    final allNotes = await getAllNotes();
    _notes = allNotes.toList();
    _notesStreamController.add(_notes);
  }

  // Getting all notes
  Stream<List<DatabaseNote>> get allNotes => _notesStreamController.stream;

  Future<DatabaseUser> createUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = getDatabaseOrThrow();
    await _ensureDbIsOpen();
    final results = await db.query(
      userTable,
      limit: 1,
      where: "email = ?",
      whereArgs: [email.toLowerCase()],
    );
    if (results.isNotEmpty) {
      throw UserAlreadyExistsException();
    }
    final userId = await db.insert(userTable, {
      emailColumn: email.toLowerCase(),
    });
    return DatabaseUser(
      id: userId,
      email: email.toLowerCase(),
    );
  }

  Future<void> closeDb() async {
    var db = db0;
    if (db == null) {
      throw DatabaseIsNotOpenException();
    } else {
      await db.close();
      db = null;
    }
  }

// Getting a usser
  Future<DatabaseUser?> getUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = getDatabaseOrThrow();
    final results = await db.query(
      userTable,
      limit: 1,
      where: "email = ?",
      whereArgs: [email.toLowerCase()],
    );
    if (results.isEmpty) {
      throw CouldNotFindUserException();
    } else {
      return DatabaseUser.fromRow(results.first);
    }
  }

  // Creating a Note
  Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
    await _ensureDbIsOpen();
    final db = getDatabaseOrThrow();
// Make sure owner exists in the database with the correct credentials
    final dbUser = await getUser(email: owner.email);
    if (dbUser != owner) {
      throw CouldNotFindUserException();
    }
    const text = "";
    // create the note
    final noteId = await db.insert(noteTable, {
      userIdColumn: owner.id,
      textColumn: text,
      isSyncedWithCloudColumn: 1,
    });
    final note = DatabaseNote(
      id: noteId,
      userId: owner.id,
      text: text,
      isSyncedWithCloud: true,
    );
    _notes.add(note);
    _notesStreamController.add(_notes);
    return note;
  }

  // Delete a Note
  Future<void> deleteNote({required int id}) async {
    await _ensureDbIsOpen();
    final db = getDatabaseOrThrow();
    final deleteCount = await db.delete(
      noteTable,
      where: "id = ?",
      whereArgs: [id],
    );
    if (deleteCount != 1) {
      throw CouldNotDeleteNoteException();
    }
  }

// Delete All Notes
  Future<int> deleteAllNotes() async {
    await _ensureDbIsOpen();
    final db = getDatabaseOrThrow();
    return await db.delete(noteTable);
  }

  // Fetching a specific Note
  Future<DatabaseNote> getNote({required int id}) async {
    await _ensureDbIsOpen();
    final db = getDatabaseOrThrow();
    final notes = await db.query(
      noteTable,
      limit: 1,
      where: "id = ?",
      whereArgs: [id],
    );
    if (notes.isEmpty) {
      throw CouldNotFindNoteException();
    } else {
      return DatabaseNote.fromRow(notes.first);
    }
  }

// Get all Notes
  Future<Iterable<DatabaseNote>> getAllNotes() async {
    await _ensureDbIsOpen();
    final db = getDatabaseOrThrow();

    final notes = await db.query(noteTable);
    final results = notes.map((noteRow) => DatabaseNote.fromRow(noteRow));

    return results;
  }

// Updating existing Notes
  Future<DatabaseNote> updateNote({
    required DatabaseNote note,
    required String text,
  }) async {
    await _ensureDbIsOpen();
    final db = getDatabaseOrThrow();
    await getNote(id: note.id);
    final updateCount = await db.update(noteTable, {
      textColumn: text,
      isSyncedWithCloudColumn: 0,
    });
    if (updateCount == 0) {
      throw CouldNotUpdateNoteException();
    } else {
      final updatedNote = await getNote(id: note.id);
      _notes.removeWhere((note) => note.id == updatedNote.id);
      _notes.add(updatedNote);
      _notesStreamController.add(_notes);
      return updatedNote;
    }
  }

  // Getting or creatig a user
  Future<DatabaseUser?> getOrCreateUser({required String email}) async {
    await _ensureDbIsOpen();
    try {
      final user = await getUser(email: email);
      return user;
    } on CouldNotFindUserException {
      final createdUser = await createUser(email: email);
      return createdUser;
    } catch (e) {
      rethrow;
    }
  }

  Database getDatabaseOrThrow() {
    final db = db0;
    if (db == null) {
      throw DatabaseIsNotOpenException();
    } else {
      return db;
    }
  }

  // Deleting the User
  Future<void> deleteuser({required String email}) async {
    await _ensureDbIsOpen();
    final db = getDatabaseOrThrow();
    final deleteCount = await db.delete(
      userTable,
      where: "email = ?",
      whereArgs: [email.toLowerCase()],
    );
    if (deleteCount != 1) {
      throw CouldNotDeleteUserException();
    }
  }

  Future<void> openDb() async {
    if (db0 != null) {
      throw DatabaseAlreadyOpenedException();
    }
    try {
      final docsPath = await getApplicationCacheDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      db0 = db;
      // Create User Table

      await db.execute(createUserTable);

      //  Creating the Notes Table
      await db.execute(createNotesTable);
      // Reading and Caching the Notes
      await _cacheNotes();
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentDirectory();
    }
  }

  Future<void> _ensureDbIsOpen() async {
    try {
      await openDb();
    } on DatabaseAlreadyOpenedException {
      // empty
    }
  }
}

@immutable
class DatabaseUser {
  final int id;
  final String email;

  const DatabaseUser({
    required this.id,
    required this.email,
  });

  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String;

  @override
  String toString() => "Person, ID = $id, email = $email";

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class DatabaseNote {
  final int id;
  final int userId;
  final String text;
  final bool isSyncedWithCloud;

  DatabaseNote({
    required this.id,
    required this.userId,
    required this.text,
    required this.isSyncedWithCloud,
  });
  DatabaseNote.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[userIdColumn] as int,
        text = map[textColumn] as String,
        isSyncedWithCloud =
            (map[isSyncedWithCloudColumn] as int) == 1 ? true : false;

  @override
  String toString() =>
      "Note, ID = $id, userId = $userId, isSyncedWithCloud = $isSyncedWithCloud, text = $text";

  @override
  bool operator ==(covariant DatabaseNote other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
