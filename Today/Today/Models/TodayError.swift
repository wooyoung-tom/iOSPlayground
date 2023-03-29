//
//  TodayError.swift
//  Today
//
//  Created by 최우영 on 2023/03/29.
//

import Foundation

/// Types conforming to `LocalizedError` can provide localized messages
/// that describe their errors and why they occur.
enum TodayError: LocalizedError {
    
    case failedReadingReminders
    case reminderHasNoDueDate
    
    var errorDescription: String? {
        switch self {
        case .failedReadingReminders:
            return NSLocalizedString("Failed to read reminders.", comment: "failed reading reminders error description")
        case .reminderHasNoDueDate:
            return NSLocalizedString("A reminder has no due date.", comment: "reminder has no due date error description")
        }
    }
}
