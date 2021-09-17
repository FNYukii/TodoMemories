//
//  CalendarView.swift
//  TodoDiary
//
//  Created by Yu on 2021/09/17.
//

import SwiftUI
import FSCalendar
import UIKit
import RealmSwift

struct CalendarView: UIViewRepresentable{
    
    @Binding var selectedDate: Date
    
    func makeUIView(context: Context) -> UIView {
        //FSCalendarを生成
        typealias UIViewType = FSCalendar
        let fsCalendar = FSCalendar()
        fsCalendar.delegate = context.coordinator
        fsCalendar.dataSource = context.coordinator
        
        //基本スタイル
        fsCalendar.scrollDirection = .horizontal
        //ヘッダーのスタイル
        fsCalendar.appearance.headerTitleColor = UIColor.label
        fsCalendar.appearance.headerDateFormat = "yyyy年 M月"
        fsCalendar.appearance.headerMinimumDissolvedAlpha = 0
        fsCalendar.appearance.weekdayTextColor = UIColor.secondaryLabel
        //日付のスタイル
        fsCalendar.appearance.titleDefaultColor = UIColor.label
        //本日のスタイル
        fsCalendar.appearance.todayColor = .clear
        fsCalendar.appearance.titleTodayColor = .red
        //選択日のスタイル
        fsCalendar.appearance.selectionColor = UIColor.secondaryLabel
        fsCalendar.appearance.borderSelectionColor = .clear
        fsCalendar.appearance.titleSelectionColor = .white
        
        
        return fsCalendar
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        //do nothing
    }
    
    func makeCoordinator() -> Coordinator{
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, FSCalendarDelegate, FSCalendarDataSource {
        var parent:CalendarView
        init(_ parent:CalendarView){
            self.parent = parent
        }
        
        //ドットを表示されるcalendarメソッド
        func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
            //Formatter
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            
            //日記が作成された日の配列を作成
            let eventsDate: [Date] = [Date()]

                        
            //カレンダーにイベント日を設定
            for eventDate in eventsDate{
                guard let eventDate = dateFormatter.date(from: dateFormatYMD(date: eventDate)) else { return 0 }
                if date.compare(eventDate) == .orderedSame{
                    return 1
                }
            }
            return 0
        }
        
        //Date型変数を年月日のみに変換するメソッド
        func dateFormatYMD(date: Date) -> String {
            let df = DateFormatter()
            df.dateStyle = .long
            df.timeStyle = .none
            return df.string(from: date)
        }
        
        //calendarメソッド
        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            parent.selectedDate = date
        }
        
    }
    
}
