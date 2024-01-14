const dbName = "notes.db";
const noteTable = "notes";
const userTable = "user";
const idColumn = "id";
const emailColumn = "email";

const userIdColumn = "user_id";
const textColumn = "text";
const isSyncedWithCloudColumn = "is_synced_with_cloud";

// creating the User Table
const createUserTable = '''CREATE TABLE IF NOT EXISTS "user"(
            "id"  INTEGER NOT NULL,
            "email"  TEXT NOT NULL UNIQUE,
            PRIMARY KEY("id" AUTOINCREMENT)
      ); ''';

// The notes Table
const createNotesTable = ''' CREATE TABLE IF NOT EXISTS "notes"(
          "id" INTEGER NOT NULL,
          "user_id" INTEGER NOT NULL,
          "text" TEXT,
          "is_synced_with_cloud" INTEGER NOT NULL DEFAULT 0,
          FOREIGN KEY ("user_id") REFERENCES "user"("id"),
          PRIMARY KEY ("id" AUTOINCREMENT)
      );
      ''';
