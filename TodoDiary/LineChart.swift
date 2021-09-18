//
//  LineChart.swift
//  TodoDiary
//
//  Created by Yu on 2021/09/19.
//

import Charts
import SwiftUI
import RealmSwift

struct LineChart : UIViewRepresentable {
    
    func makeUIView(context: Context) -> LineChartView {
        //当月の日数を取得
        let currentDate = Date()
        let calendar = Calendar(identifier: .gregorian)
        let currentMonth = calendar.component(.month, from: currentDate)
        let dayCount = dayCount(month: currentMonth)
        print(dayCount)
        
        //折れ線グラフ用の日別Todo完了数データを取得
        var lineChartEntry : [ChartDataEntry] = []
        for day in (0..<dayCount) {
            let currentYear = calendar.component(.year, from: currentDate)
            let achievedYmd = currentYear * 10000 + currentMonth * 100 + day
            let realm = try! Realm()
            let achievedTodos = realm.objects(Todo.self).filter("isAchieved == true && achievedYmd = \(achievedYmd)")
            lineChartEntry.append(ChartDataEntry(x: Double(day), y: Double(achievedTodos.count)))
        }
        
        //折れ線を生成
        let data = LineChartData()
        let dataSet = LineChartDataSet(entries: lineChartEntry)
        //折れ線のスタイルをカスタマイズ
        dataSet.drawCirclesEnabled = false
        dataSet.setColor(UIColor.systemBlue)
        //チャートを生成して折れ線をセット
        let lineChartView = LineChartView()
        data.append(dataSet)
        lineChartView.data = data
        //チャートのスタイルをカスタマイズ
        lineChartView.data!.setDrawValues(false)
        lineChartView.rightAxis.enabled = false
        lineChartView.leftAxis.axisMinimum = 0.0
        lineChartView.leftAxis.granularity = 1.0
        
        return lineChartView
    }
    
    func updateUIView(_ uiView: LineChartView, context: Context) {
        //
    }
    
    func dayCount(month: Int) -> Int {
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.year = 2012
        components.month = month + 1
        components.day = 0
        let date = calendar.date(from: components)!
        return calendar.component(.day, from: date)
    }
    
}
