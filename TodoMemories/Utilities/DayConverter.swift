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
}
