//
//  Events.swift
//  test
//
//  Created by Mack Ndanina on 2025-08-22.
//

import SwiftUI

enum EventCategory: String, CaseIterable, Identifiable, Codable {
    case sports = "Sports"
    case deadline = "Deadline"
    case exam = "Exam"
    case club = "Club"

    var id: String { rawValue }
    var icon: String {
        switch self {
        case .sports: return "sportscourt"
        case .deadline: return "calendar.badge.exclamationmark"
        case .exam: return "pencil.and.list.clipboard"
        case .club: return "person.3"
        }
    }
    var color: Color {
        switch self {
        case .sports: return .green
        case .deadline: return .red
        case .exam: return .blue
        case .club: return .purple
        }
    }
}

struct CampusEvent: Identifiable, Codable, Hashable {
    let id: UUID
    var title: String
    var date: Date
    var location: String
    var category: EventCategory
    var summary: String
    var link: URL?

    init(id: UUID = UUID(), title: String, date: Date, location: String, category: EventCategory, summary: String, link: URL? = nil) {
        self.id = id
        self.title = title
        self.date = date
        self.location = location
        self.category = category
        self.summary = summary
        self.link = link
    }
}
