//
//  BarChart.swift
//  TodoDiary
//
//  Created by Yu on 2021/10/05.
//

import Charts
import SwiftUI
import RealmSwift

struct BarChart : UIViewRepresentable {
    
    let showYear: Int
    let showMonth: Int
    
    func makeUIView(context: Context) -> BarChartView {
        let barChartView = BarChartView()
        barChartView.legend.enabled = false //凡例を非表示
        barChartView.rightAxis.enabled = false //左Y軸を非表示
        barChartView.leftAxis.axisMinimum = 0.0 //左Y軸の最小値
        barChartView.leftAxis.granularity = 1.0 //左Y軸の区切り値
        return barChartView
    }
    
    func updateUIView(_ uiView: BarChartView, context: Context) {
        
        //当月の日数を取得
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.year = 2012
        components.month = showMonth + 1
        components.day = 0
        let date = calendar.date(from: components)!
        let dayCount = calendar.component(.day, from: date)
        
        //当月のTodo日別達成数の配列を生成
        var achieveCounts: [Int] = []
        for day in (1..<dayCount + 1) {
            let achievedYmd = showYear * 10000 + showMonth * 100 + day
            let realm = Todo.customRealm()
            let achievedTodos = realm.objects(Todo.self).filter("isAchieved == true && achievedYmd = \(achievedYmd)")
            achieveCounts.append(achievedTodos.count)
        }
        
//        //achieveCountsを元に棒グラフ用のデータを生成
//        var entries : [ChartDataEntry] = []
//        for day in (0..<dayCount) {
//            entries.append(ChartDataEntry(x: Double(day), y: Double(achieveCounts[day])))
//        }
        
        let rawData: [Int] = [5, 4, 2, 4, 1, 2, 5, 1, 2, 5, 2, 3, 1, 4, 2, 3, 3, 2, 4, 1, 0, 4, 2, 0, 2, 2, 1, 3, 3, 2]
        let entries = rawData.enumerated().map { BarChartDataEntry(x: Double($0.offset + 1), y: Double($0.element)) }
        
        //データセットを生成
        let dataSet = BarChartDataSet(entries: entries)
        dataSet.drawValuesEnabled = false //データ値を非表示
        dataSet.setColor(UIColor.systemBlue) //棒グラフの色を設定
        
        //棒グラフにデータセットを設定
        let data = BarChartData(dataSet: dataSet)
        uiView.data = data
        
        
        //チャートY軸の表示する高さを設定
        let maxAchieveCount = achieveCounts.max() ?? 0
        if(maxAchieveCount > 5){
            uiView.leftAxis.axisMaximum = Double(maxAchieveCount)
        }else{
            uiView.leftAxis.axisMaximum = 5.0
        }
        
        
        
    }
        
}
