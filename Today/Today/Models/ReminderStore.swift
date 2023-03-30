//
//  ReminderStore.swift
//  Today
//
//  Created by 최우영 on 2023/03/29.
//

import EventKit
import Foundation

/// You can't override methods in `final` classes. The compiler will display a warning if you try to subclass `ReminderStore`.
final class ReminderStore {
    static let shared = ReminderStore()
    
    private let ekStore = EKEventStore()
    
    /// - Returns
    ///   - true if the reminder authorization status is `.authorized`.
    var isAvailable: Bool {
        EKEventStore.authorizationStatus(for: .reminder) == .authorized
    }
    
    func requestAccess() async throws {
        // stores the reminder authorization status.
        let status = EKEventStore.authorizationStatus(for: .reminder)
        
        // The function will return if the user has granted access,
        // ask permission if the user hasn't yet decided,
        // or throw an error for other conditions.
        switch status {
        case .authorized:
            return
        case .restricted:
            throw TodayError.accessRestricted
        case .notDetermined:
            let accessGranted = try await ekStore.requestAccess(to: .reminder)
            guard accessGranted else {
                throw TodayError.accessDenied
            }
        case .denied:
            throw TodayError.accessDenied
        @unknown default:
            throw TodayError.unknown
        }
    }
    
    func readAll() async throws -> [Reminder] {
        guard isAvailable else {
            throw TodayError.accessDenied
        }
        
        // This predicate narrows the results to only reminder items.
        // If you choose, you can further narrow the results to reminders from specific calendars.
        let predicate = ekStore.predicateForReminders(in: nil)
        let ekReminders = try await ekStore.reminders(matching: predicate)
        let reminders: [Reminder] = try ekReminders.compactMap { ekReminder in
            do {
                return try Reminder(with: ekReminder)
            } catch TodayError.reminderHasNoDueDate {
                return nil
            }
        }
        return reminders
    }
}
