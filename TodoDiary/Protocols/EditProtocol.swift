//
//  MyProtocol.swift
//  TodoDiary
//
//  Created by Yu on 2021/09/16.
//

import Foundation

protocol EditProtocol {
    func reloadRecords()
    func getSelectedDiaryId() -> Int
}