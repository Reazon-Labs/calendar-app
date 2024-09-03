//
//  DateUtils.swift
//  Calendar
//
//  Created by jocke on 03/09/2024.
//

import Foundation

public struct DateUtils {
    /// - Returns: a date formatter in format "MMMM yyyy"
    /// (example: "September 2024")
    public static var monthYearFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        
        return formatter
    }
    
    /// - Parameter date: a date in the month
    /// - Returns: amount of days in the month (28...31)
    public static func daysInMonth(_ date: Date) -> Int {
        let range = Calendar.current.range(of: .day, in: .month, for: date)!
        return range.count
    }
    
    /// - Parameter date: a date in the month
    /// - Returns: The weekday (1...7) where 1 is Sunday
    ///
    ///  See: ```weekDayFromMonday(_:)```
    public static func firstWeekDayOfMonth(_ date: Date) -> Int {
        let inputComponents = Calendar.current.dateComponents([.year, .month], from: date)
        
        let targetComponents = DateComponents(year: inputComponents.year!, month: inputComponents.month!)
        let targetDate = Calendar.current.date(from: targetComponents)!
        
        return Calendar.current.component(.weekday, from: targetDate)
    }
    
    /// Transform a sunday-based weekday to a monday-based
    /// - Parameter day: The weekday in sunday-based calendar
    /// - Returns: The weekday in monday-based calendar
    public static func weekDayFromMonday(_ day: Int) -> Int {
        return day == 1 ? 7 : day-1
    }
}
