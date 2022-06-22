//
//  AchievedDay.swift
//  TodoMemories
//
//  Created by Yu on 2022/06/22.
//

import Foundation

struct Day: Identifiable, Equatable {
    var id = UUID()
    var ymd: Int
    var achievedTodos: [Todo]
}
