class CloudStorageException implements Exception {
  const CloudStorageException();
}

// C in Crud is for Create
class CouldNotCreateNoteException extends CloudStorageException {}

// R in Crud is for Read
class CouldNotGetAllNotesException extends CloudStorageException {}

// U in Crud is for Update
class CouldNotUpdateNoteException extends CloudStorageException {}

// D in Crud is for Delete
class CouldNotDeleteNoteException extends CloudStorageException {}
