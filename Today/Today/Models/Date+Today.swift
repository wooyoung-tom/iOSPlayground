//
//  Date+Today.swift
//  Today
//
//  Created by 최우영 on 2023/03/27.
//

import Foundation

extension Date {
    var dayAndTimeText: String {
        // create a string represnetation of the time,
        // and assign the result to a constant named timeText
        let timeText = formatted(date: .omitted, time: .shortened)
        
        // tests whether this date is in the current calendar day.
        if Locale.current.calendar.isDateInToday(self) {
            let timeFormat = NSLocalizedString("Today at %@", comment: "Today at time format string")
            
            // create a string by applying timeFormat to the time text, and return the result.
            return String(format: timeFormat, timeText)
        } else {
            // create a formatted string when the provided date isn't in the current calendar date.
            let dateText = formatted(.dateTime.month(.abbreviated).day())
            
            // create a formatted string for displaying the date and time,
            // and assign the result to a constant named dateAndTimeFormat.
            let dateAndTimeFormat = NSLocalizedString("%@ at %@", comment: "Date and time format string")
            
            // create a string by applyting dateAndTimeFormat to the date and time text,
            // and return the result.
            return String(format: dateAndTimeFormat, dateText, timeText)
        }
    }
    
    // create a computed string property named dayText that returns a static string
    // if this date is in the current calendar day.
    var dayText: String {
        if Locale.current.calendar.isDateInToday(self) {
            return NSLocalizedString("Today", comment: "Today due date description")
        } else {
            return formatted(.dateTime.month().day().weekday(.wide))
        }
    }
}
