// Project.swift — REMOVED
//
// This file previously defined `struct Project: Identifiable, Codable`
// along with ProjectType, ProjectStatus, and StitchType enums.
//
// It was never used by any live call site — no view, service, or
// manager in the app instantiated Project(userId:...) or decoded it
// from JSON. The active project model is `ProjectModel` (ProjectModel.swift),
// which is backed by DatabaseManager and used throughout the app.
//
// ProjectType, ProjectStatus, and StitchType have been preserved inline
// below as lightweight enums in case they are needed for UI display labels
// or future ProjectModel expansion — but they carry no persistence burden.

import Foundation

enum ProjectType: String, CaseIterable, Codable {
    case scarf, beanie, sweater, mittens, blanket, other

    var displayName: String {
        rawValue.prefix(1).uppercased() + rawValue.dropFirst()
    }
}

enum ProjectStatus: String, CaseIterable, Codable {
    case active, paused, completed, archived

    var displayName: String {
        rawValue.prefix(1).uppercased() + rawValue.dropFirst()
    }
}

enum StitchType: String, CaseIterable, Codable {
    case stockinette, garter, ribbing, cable, lace

    var displayName: String {
        rawValue.prefix(1).uppercased() + rawValue.dropFirst()
    }
}
