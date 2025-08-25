//
//  FourthView.swift
//  test
//
//  Created by Tobi Ayeni on 2025-05-08.
//
import SwiftUI

struct CalendarView: View {
    @State private var events: [CampusEvent] = []
    @State private var search: String = ""
    @State private var selectedCategory: EventCategory? = nil
    @State private var isLoading = true
    @State private var error: String?

    // ⬇️ use the live API-backed service instead of the mock
    private let service: EventServicing = APIEventService()

    var body: some View {
        NavigationStack {
            ZStack {
                Color.green.ignoresSafeArea()
                Circle().scale(1.7).foregroundColor(.white.opacity(0.15))
                Circle().scale(1.35).foregroundColor(.white)

                content
                    // tiny top spacer so the title has room on notched devices
                    .safeAreaInset(edge: .top) { Color.clear.frame(height: 0.1) }
                    // leave room for your custom bottom tab bar
                    .safeAreaInset(edge: .bottom) { Color.clear.frame(height: 88) }
            }
            .navigationTitle("Campus Events")
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color.clear, for: .navigationBar)
        }
        .task { await load() }
    }

    // MARK: - Main content
    @ViewBuilder
    private var content: some View {
        VStack {
            filterBar
                .padding(.horizontal)
                .padding(.top, 8)

            if isLoading {
                ProgressView("Loading events…")
                    .padding(.top, 40)
            } else if let error {
                Text(error)
                    .foregroundColor(.red)
                    .padding(.top, 40)
            } else if filtered.isEmpty {
                Text("No upcoming events.")
                    .foregroundColor(.black.opacity(0.6))
                    .padding(.top, 40)
            } else {
                List {
                    ForEach(grouped.keys.sorted(), id: \.self) { day in
                        Section(
                            header: Text(day.formatted(date: .abbreviated, time: .omitted))
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.black) // visible on green/white bg
                        ) {
                            ForEach(grouped[day]!) { event in
                                NavigationLink(value: event) {
                                    EventRow(event: event) // keeps your dark row + white text
                                }
                            }
                        }
                    }
                }
                .refreshable { await load() }              // ⬅️ pull-to-refresh
                .scrollContentBackground(.hidden)
                .background(Color.clear)
                .listStyle(.insetGrouped)
                .navigationDestination(for: CampusEvent.self) { event in
                    EventDetailView(event: event)
                }
            }
        }
    }

    // MARK: - Filtering / Grouping

    private var filtered: [CampusEvent] {
        events.filter { e in
            (selectedCategory == nil || e.category == selectedCategory!)
            && (search.isEmpty
                || e.title.localizedCaseInsensitiveContains(search)
                || e.location.localizedCaseInsensitiveContains(search))
        }
    }

    private var grouped: [Date: [CampusEvent]] {
        Dictionary(grouping: filtered) { Calendar.current.startOfDay(for: $0.date) }
    }

    // MARK: - Filter bar (unchanged styling)

    private var filterBar: some View {
        VStack(spacing: 10) {
            // SEARCH
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.black.opacity(0.5))

                TextField(
                    "",
                    text: $search,
                    prompt: Text("Search events, locations…")
                        .foregroundColor(.black.opacity(0.4))
                )
                .foregroundColor(.black)
                .tint(.black)

                if !search.isEmpty {
                    Button {
                        search = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.black.opacity(0.35))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .shadow(radius: 2, y: 1)
            )

            // CATEGORIES
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    CategoryChip(
                        title: "All",
                        icon: "rectangle.3.group",
                        color: .black,
                        isSelected: selectedCategory == nil
                    ) { selectedCategory = nil }

                    ForEach(EventCategory.allCases) { cat in
                        CategoryChip(
                            title: cat.rawValue,
                            icon: cat.icon,
                            color: cat.color,
                            isSelected: selectedCategory == cat
                        ) { selectedCategory = cat }
                    }
                }
                .padding(.vertical, 2)
            }
        }
    }

    // MARK: - Loading

    private func load() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let fetched = try await service.fetchUpcoming()
            // keep your existing behavior
            events = fetched
        } catch {
            self.error = "Couldn’t load events."
        }
    }
}

// MARK: - Reused UI pieces (unchanged)

private struct CategoryChip: View {
    let title: String
    let icon: String
    let color: Color
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                Text(title)
            }
            .font(.subheadline)
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(radius: isSelected ? 3 : 1, y: 1)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? color : .clear, lineWidth: 2)
                    )
            )
            .foregroundColor(.black)
        }
    }
}

private struct EventRow: View {
    let event: CampusEvent

    var body: some View {
        HStack(spacing: 12) {
            ZstackIcon(category: event.category)

            VStack(alignment: .leading, spacing: 4) {
                Text(event.title)
                    .font(.headline)
                    .foregroundColor(.white) // your original look
                Text(event.location)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                Text(event.date.formatted(date: .omitted, time: .shortened))
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
            Spacer()
        }
        .padding(.vertical, 6)
    }
}

private struct ZstackIcon: View {
    let category: EventCategory
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(category.color.opacity(0.15))
                .frame(width: 44, height: 44)
            Image(systemName: category.icon)
                .foregroundColor(category.color)
        }
    }
}
