//
//  DayConverter.swift
//  TodoMemories
//
//  Created by Yu on 2022/06/22.
//

import Foundation

class DayConverter {
    
    // Date -> 20210923
    static func toInt(from: Date) -> Int {
        let inputDate = from
        let calendar = Calendar(identifier: .gregorian)
        let year = calendar.component(.year, from: inputDate)
        let month = calendar.component(.month, from: inputDate)
        let day = calendar.component(.day, from: inputDate)
        return year * 10000 + month * 100 + day
    }
    
    // DateComponents -> "Sunday, February 13, 2022", "2022年2月13日 日曜日"
    static func toStringUpToWeekday(from: Int) -> String {
        let date = toDate(from: from)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        return dateFormatter.string(from: date)
    }
    
    // 20210923 -> Date
    static func toDate(from: Int) -> Date {
        let year = from / 10000
        let month = (from % 10000) / 100
        let day = (from % 100)
        let date = DateComponents(calendar: Calendar.current, year: year, month: month, day: day).date!
        return date
    }
    
    // Date -> "14:53"
    static func toHmText(from: Date) -> String {
        let inputDate = from
        let calendar = Calendar(identifier: .gregorian)
        let hour = calendar.component(.hour, from: inputDate)
        let minute = calendar.component(.minute, from: inputDate)
        let hourStr = String(NSString(format: "%02d", hour))
        let minuteStr = String(NSString(format: "%02d", minute))
        return hourStr + ":" + minuteStr
    }
}
