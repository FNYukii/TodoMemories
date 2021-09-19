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
        var components = DateComponents()
        components.year = 2012
        components.month = currentMonth + 1
        components.day = 0
        let date = calendar.date(from: components)!
        let dayCount = calendar.component(.day, from: date)
        
        //当月のTodo日別達成数の配列を生成
        var achieveCounts: [Int] = []
        for day in (0..<dayCount) {
            let currentYear = calendar.component(.year, from: currentDate)
            let achievedYmd = currentYear * 10000 + currentMonth * 100 + day
            let realm = try! Realm()
            let achievedTodos = realm.objects(Todo.self).filter("isAchieved == true && achievedYmd = \(achievedYmd)")
            achieveCounts.append(achievedTodos.count)
        }
        
        //achieveCountsを元に折れ線用のデータを生成
        var lineChartEntry : [ChartDataEntry] = []
        for day in (0..<dayCount) {
            lineChartEntry.append(ChartDataEntry(x: Double(day), y: Double(achieveCounts[day])))
        }
        
        //折れ線を生成
        let data = LineChartData()
        let dataSet = LineChartDataSet(entries: lineChartEntry)
        
        //折れ線のスタイルをカスタマイズ
        dataSet.drawCirclesEnabled = false //折れ線グラフのデータ値の丸を非表示
        dataSet.setColor(UIColor.systemBlue) //折れ線グラフの色
        
        //チャートを生成して折れ線をセット
        let lineChartView = LineChartView()
        data.append(dataSet)
        lineChartView.data = data
        
        //チャートのスタイルをカスタマイズ
        lineChartView.legend.enabled = false //チャートのデータ概要非表示
        lineChartView.data!.setDrawValues(false) //折れ線グラフのデータ値非表示
        lineChartView.rightAxis.enabled = false //右側のY軸目盛り非表示
        lineChartView.leftAxis.axisMinimum = 0.0 //左側のY軸目盛り最小値
        lineChartView.leftAxis.granularity = 1.0 //左側のY軸目盛りの区切り地
        lineChartView.doubleTapToZoomEnabled = false //ダブルタップでズームを無効
        lineChartView.scaleXEnabled = false //X軸ピンチアウトを無効
        lineChartView.scaleYEnabled = false //Y軸ピンチアウトを無効
        lineChartView.highlightPerDragEnabled = false //ドラッグでハイライト線表示を無効
        
        //チャートY軸の表示する高さを設定
        let maxAchieveCount = achieveCounts.max() ?? 0
        if(maxAchieveCount > 5){
            lineChartView.leftAxis.axisMaximum = Double(maxAchieveCount)
        }else{
            lineChartView.leftAxis.axisMaximum = 5.0
        }
        
        return lineChartView
    }
    
    func updateUIView(_ uiView: LineChartView, context: Context) {
        //
    }
        
}
