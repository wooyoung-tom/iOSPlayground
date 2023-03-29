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
}
