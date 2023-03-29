//
//  EKEventStore+AsyncFetch.swift
//  Today
//
//  Created by 최우영 on 2023/03/29.
//

import EventKit

/// The `async` keyword after the functions's parameters indicates that this function can execute asynchronously.
/// The `await` keyword indicates that your task suspends until the continuation resumes.

extension EKEventStore {
    func reminders(matching predicate: NSPredicate) async throws -> [EKReminder] {
        try await withCheckedThrowingContinuation { continuation in
            fetchReminders(matching: predicate) { reminders in
                if let reminders {
                    continuation.resume(returning: reminders)
                } else {
                    continuation.resume(throwing: TodayError.failedReadingReminders)
                }
            }
        }
    }
}
