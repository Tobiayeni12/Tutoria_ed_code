//
//  EventService.swift
//  test
//
//  Created by Mack Ndanina on 2025-08-22.
//

//
//  EventService.swift
//

import Foundation

// MARK: - Protocol

protocol EventServicing {
    func fetchUpcoming() async throws -> [CampusEvent]
}

// MARK: - API models (for decoding the JSON file)

struct APIEvent: Decodable {
    let id: String?
    let title: String
    let date: Date
    let location: String
    let summary: String
    let url: URL?
    let category: String?
}

// MARK: - Live service (pulls JSON from GitHub Raw)

final class APIEventService: EventServicing {
    // Use the **RAW** file URL (not the GitHub HTML page)
    private let feedURL = URL(string:
        "https://raw.githubusercontent.com/Tobiayeni12/Tutoria_ed_code/main/event-feed/usask.json"
    )!

    private let decoder: JSONDecoder = {
        let d = JSONDecoder()
        d.dateDecodingStrategy = .iso8601
        return d
    }()

    func fetchUpcoming() async throws -> [CampusEvent] {
        var request = URLRequest(url: feedURL)
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse else {
            throw NSError(domain: "EventService", code: -1,
                          userInfo: [NSLocalizedDescriptionKey: "No HTTP response"])
        }

        guard http.statusCode == 200 else {
            let body = String(data: data, encoding: .utf8) ?? "<non-utf8>"
            print("❌ EventService HTTP \(http.statusCode). Body preview:\n\(body.prefix(500))")
            throw NSError(domain: "EventService", code: http.statusCode,
                          userInfo: [NSLocalizedDescriptionKey: "Feed returned HTTP \(http.statusCode)"])
        }

        do {
            let items = try decoder.decode([APIEvent].self, from: data)
            print("✅ EventService decoded \(items.count) items (\(data.count) bytes)")

            let mapped = items.map {
                CampusEvent(
                    id: $0.id ?? UUID().uuidString,
                    title: $0.title,
                    date: $0.date,
                    location: $0.location,
                    category: EventCategory(fromString: $0.category ?? ""),
                    summary: $0.summary,
                    link: $0.url
                )
            }
            return mapped.sorted { $0.date < $1.date }
        } catch {
            let body = String(data: data, encoding: .utf8) ?? "<non-utf8>"
            print("❌ EventService JSON decode failed: \(error)\nBody preview:\n\(body.prefix(500))")
            throw NSError(domain: "EventService", code: -2,
                          userInfo: [NSLocalizedDescriptionKey: "Invalid feed format"])
        }
    }
}

// MARK: - Mock service (kept for previews / offline)

struct MockEventService: EventServicing {
    func fetchUpcoming() async throws -> [CampusEvent] {
        let cal = Calendar.current
        func d(_ offset: Int, _ hour: Int) -> Date {
            cal.date(bySettingHour: hour, minute: 0, second: 0,
                     of: cal.date(byAdding: .day, value: offset, to: Date())!)!
        }

        return [
            CampusEvent(
                title: "Huskies vs. Bisons (Football)",
                date: d(1, 19),
                location: "Griffiths Stadium",
                category: .sports,
                summary: "Home opener. Students free with ID.",
                link: URL(string: "https://huskies.usask.ca")
            ),
            CampusEvent(
                title: "Fall Tuition Payment Deadline",
                date: d(3, 17),
                location: "PAWS / Online",
                category: .deadline,
                summary: "Avoid late fees. Set a reminder."
            ),
            CampusEvent(
                title: "CS Club Hack Night",
                date: d(5, 18),
                location: "Thorvaldson 105",
                category: .community,
                summary: "Pizza + project showcase. New members welcome!",
                link: URL(string: "https://csclub.usask.ca")
            )
        ]
        .sorted { $0.date < $1.date }
    }
}
