//
//  Events.swift
//

import SwiftUI

enum EventCategory: String, CaseIterable, Identifiable, Codable {
    case sports = "Sports"
    case deadline = "Deadline"
    case exam = "Exam"
    case community = "Community"
    case other = "Other"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .sports:     return "sportscourt"
        case .deadline:   return "calendar.badge.exclamationmark"
        case .exam:       return "pencil.and.list.clipboard"
        case .community:  return "person.3"
        case .other:      return "sparkles"
        }
    }

    var color: Color {
        switch self {
        case .sports:     return .green
        case .deadline:   return .red
        case .exam:       return .blue
        case .community:  return .purple
        case .other:      return .gray
        }
    }

    /// Map free-text coming from feeds into our enum.
    init(fromString s: String) {
        switch s.lowercased() {
        case "sports", "sport", "game":
            self = .sports
        case "deadline", "due":
            self = .deadline
        case "exam", "midterm", "final":
            self = .exam
        case "club", "community", "event", "social", "volunteer":
            self = .community
        default:
            self = .other
        }
    }
}

struct CampusEvent: Identifiable, Codable, Hashable {
    /// String id so we can accept server/generator ids & UUIDs
    var id: String
    var title: String
    var date: Date
    var location: String
    var category: EventCategory
    var summary: String
    var link: URL?

    init(
        id: String = UUID().uuidString,
        title: String,
        date: Date,
        location: String,
        category: EventCategory,
        summary: String,
        link: URL? = nil
    ) {
        self.id = id
        self.title = title
        self.date = date
        self.location = location
        self.category = category
        self.summary = summary
        self.link = link
    }
}
