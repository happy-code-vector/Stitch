// CoreDataManager.swift — REMOVED
//
// This file previously contained a CoreDataManager backed by
// NSPersistentCloudKitContainer. It was never wired into AppState,
// ContentView, or any live call site — every active code path uses
// DatabaseManager (raw SQLite) exclusively.
//
// Keeping a second persistence stack alive at startup carried real costs:
//   • iCloud container entitlement required (crashes without it)
//   • A background migration queue ran on every cold launch
//   • NSManagedObjectContext instances were created and leaked
//   • Entities.swift defined NSManagedObject subclasses with no .xcdatamodel
//     backing them, which would crash at runtime on Core Data fetch
//
// Decision: deleted in favour of the single DatabaseManager source of truth.
// If iCloud sync is desired in the future, consider CloudKit directly or
// SwiftData, both of which integrate cleanly with the existing SQLite schema.
