//
//  EventService.swift
//  test
//
//  Created by Mack Ndanina on 2025-08-22.
//

import Foundation

protocol EventServicing {
    func fetchUpcoming() async throws -> [CampusEvent]
}

struct MockEventService: EventServicing {
    func fetchUpcoming() async throws -> [CampusEvent] {
        let cal = Calendar.current
        func d(_ dayOffset: Int, hour: Int) -> Date {
            cal.date(bySettingHour: hour, minute: 0, second: 0, of: cal.date(byAdding: .day, value: dayOffset, to: Date())!)!
        }
        return [
            CampusEvent(title: "Huskies vs. Bisons (Football)", date: d(1, hour: 19), location: "Griffiths Stadium", category: .sports, summary: "Home opener. Students free with ID.", link: URL(string: "https://huskies.usask.ca")),
            CampusEvent(title: "Fall Tuition Payment Deadline", date: d(3, hour: 17), location: "PAWS / Online", category: .deadline, summary: "Avoid late fees. Set a reminder."),
            CampusEvent(title: "CHEM 112 Midterm", date: d(7, hour: 9), location: "Arts 241", category: .exam, summary: "Bring student card & non-programmable calculator."),
            CampusEvent(title: "CS Club Hack Night", date: d(5, hour: 18), location: "Thorvaldson 105", category: .club, summary: "Pizza + project showcase. New members welcome!", link: URL(string: "https://csclub.usask.ca"))
        ]
        .sorted { $0.date < $1.date }
    }
}
