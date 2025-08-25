//
//  EventDetailView.swift
//  test
//
//  Created by Mack Ndanina on 2025-08-22.
//

import SwiftUI
import EventKit
import EventKitUI

struct EventDetailView: View {
    let event: CampusEvent
    @State private var showingCalendarEditor = false
    @State private var calendarPermDenied = false

    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(radius: 3, y: 1)
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: event.category.icon)
                            .foregroundColor(event.category.color)
                        Text(event.title)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                        Spacer()
                    }
                    HStack {
                        Image(systemName: "calendar")
                        Text(event.date.formatted(date: .complete, time: .shortened))
                    }
                    .foregroundColor(.black.opacity(0.6))
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                        Text(event.location)
                    }
                    .foregroundColor(.black.opacity(0.6))
                    Text(event.summary)
                        .foregroundColor(.black)
                        .padding(.top, 6)
                }
                .padding()
            }
            .padding(.horizontal)

            if let link = event.link {
                Link(destination: link) {
                    Label("More info", systemImage: "link")
                        .foregroundColor(Color.blue)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white)
                                .shadow(radius: 2, y: 1)
                        )
                }
                .padding(.horizontal)
            }

            Button {
                Task { await addToCalendar() }
            } label: {
                Label("Add to Apple Calendar", systemImage: "plus.circle.fill")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.green))
                    .foregroundColor(.black)
            }
            .padding(.horizontal)

            Spacer()
        }
        .background(
            ZStack {
                Color.green.ignoresSafeArea()
                Circle().scale(1.7).foregroundColor(.white.opacity(0.15))
                Circle().scale(1.35).foregroundColor(.white)
            }
        )
        .navigationTitle("Event")
        .sheet(isPresented: $showingCalendarEditor) {
            EventEditView(event: event)
        }
        .alert("Calendar access denied", isPresented: $calendarPermDenied) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Enable access in Settings → Privacy → Calendars to add events.")
        }
    }

    private func addToCalendar() async {
        let store = EKEventStore()
        switch EKEventStore.authorizationStatus(for: .event) {
        case .authorized:
            showingCalendarEditor = true
        case .notDetermined:
            do {
                let granted = try await store.requestAccess(to: .event)
                showingCalendarEditor = granted
                calendarPermDenied = !granted
            } catch {
                calendarPermDenied = true
            }
        default:
            calendarPermDenied = true
        }
    }
}

private struct EventEditView: UIViewControllerRepresentable {
    let event: CampusEvent

    func makeUIViewController(context: Context) -> EKEventEditViewController {
        let store = EKEventStore()
        let controller = EKEventEditViewController()
        controller.eventStore = store

        let ekEvent = EKEvent(eventStore: store)
        ekEvent.title = event.title
        ekEvent.location = event.location
        ekEvent.startDate = event.date
        ekEvent.endDate = event.date.addingTimeInterval(60 * 60)
        ekEvent.notes = event.summary
        controller.event = ekEvent

        controller.editViewDelegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: EKEventEditViewController, context: Context) {}
    func makeCoordinator() -> Coordinator { Coordinator() }

    final class Coordinator: NSObject, EKEventEditViewDelegate {
        func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
            controller.dismiss(animated: true)
        }
    }
}
