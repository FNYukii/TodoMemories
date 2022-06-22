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
    
    //  ["0", "1", "2", "3", ...] , ["0時", "1時", "2時", "3時", ...]
    static func hourStrings() -> [String] {
        var hourStrings: [String] = []
        for index in 0 ..< 24 {
            // DateCompontentsを生成
            var dateComponents = DateComponents()
            dateComponents.hour = index
            let date = Calendar.current.date(from: dateComponents)!
            // dayStringを生成
            let dateFormatter = DateFormatter()
            dateFormatter.setLocalizedDateFormatFromTemplate("H")
            let hourString = dateFormatter.string(from: date)
            // 配列に追加
            hourStrings.append(hourString)
        }
        return hourStrings
    }
    
    // ["1", "2", "3", ...] , ["1日", "2日", "3日", ...]
    static func dayStrings() -> [String] {
        var dayStrings: [String] = []
        for index in 0 ..< 31 {
            // DateCompontentsを生成
            var dateComponents = DateComponents()
            dateComponents.day = index + 1
            let date = Calendar.current.date(from: dateComponents)!
            // dayStringを生成
            let dateFormatter = DateFormatter()
            dateFormatter.setLocalizedDateFormatFromTemplate("d")
            let dayString = dateFormatter.string(from: date)
            // 配列に追加
            dayStrings.append(dayString)
        }
        return dayStrings
    }
    
    //  ["1", "2", "3", ...] , ["1月", "2月", "3月", ...]
    static func monthStrings() -> [String] {
        var monthStrings: [String] = []
        for index in 0 ..< 12 {
            // DateCompontentsを生成
            var dateComponents = DateComponents()
            dateComponents.month = index + 1
            let date = Calendar.current.date(from: dateComponents)!
            // dayStringを生成
            let dateFormatter = DateFormatter()
            dateFormatter.setLocalizedDateFormatFromTemplate("MMM")
            let monthString = dateFormatter.string(from: date)
            // 配列に追加
            monthStrings.append(monthString)
        }
        return monthStrings
    }
    
    // 年単位でシフトされた、年が入ったDateComponents
    static func nowShiftedByYear(offset: Int) -> DateComponents {
        let date = Date()
        let shiftedDate = Calendar.current.date(byAdding: .year, value: offset, to: date)!
        let dateComponents = Calendar.current.dateComponents(in: TimeZone.current, from: shiftedDate)
        return dateComponents
    }
    
    // 月単位でシフトされた、年・月が入ったDateComponents
    static func nowShiftedByMonth(offset: Int) -> DateComponents {
        let date = Date()
        let shiftedDate = Calendar.current.date(byAdding: .month, value: offset, to: date)!
        let dateComponents = Calendar.current.dateComponents(in: TimeZone.current, from: shiftedDate)
        return dateComponents
    }
    
    //　日単位でシフトされた、年・月・日が入ったDateComponents
    static func nowShiftedByDay(offset: Int) -> DateComponents {
        let date = Date()
        let shiftedDate = Calendar.current.date(byAdding: .day, value: offset, to: date)!
        let dateComponents = Calendar.current.dateComponents(in: TimeZone.current, from: shiftedDate)
        return dateComponents
    }
    
    // Date -> "February 2022", "2022年 2月"
    static func toStringUpToMonth(from: DateComponents) -> String {
        let date = Calendar.current.date(from: from)!
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("YYYY MMMM")
        return dateFormatter.string(from: date)
    }
    
    // その月の日数
    static func dayCountAtTheMonth(year: Int, month: Int) -> Int {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month + 1
        dateComponents.day = 0
        let date = Calendar.current.date(from: dateComponents)!
        let dayCount = Calendar.current.component(.day, from: date)
        return dayCount
    }
}
