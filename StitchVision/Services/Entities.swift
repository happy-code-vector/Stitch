// Entities.swift — REMOVED
//
// This file previously defined NSManagedObject subclasses
// (UserProfileEntity, ProjectEntity, SessionEntity, PatternEntity,
// SettingsEntity) for use with CoreDataManager.
//
// CoreDataManager has been removed (see CoreDataManager.swift).
// These entity classes had no .xcdatamodel file backing them, meaning
// any Core Data fetch request targeting them would crash at runtime.
//
// The active data models are:
//   • UserProfile  — plain Swift struct, persisted by DatabaseManager
//   • ProjectModel — plain Swift struct, persisted by DatabaseManager
//   • SessionModel — plain Swift struct, persisted by DatabaseManager
//   • KnittingPattern — Codable struct, persisted by DatabaseManager
