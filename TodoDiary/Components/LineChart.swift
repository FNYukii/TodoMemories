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
    
    let showYear: Int
    let showMonth: Int
    
    func makeUIView(context: Context) -> LineChartView {

        //チャートを生成
        let lineChartView = LineChartView()
        
        //チャートのスタイルをカスタマイズ
        lineChartView.legend.enabled = false //チャートのデータ概要非表示
        lineChartView.rightAxis.enabled = false //右側のY軸目盛り非表示
        lineChartView.leftAxis.axisMinimum = 0.0 //左側のY軸目盛り最小値
        lineChartView.leftAxis.granularity = 1.0 //左側のY軸目盛りの区切り地
        lineChartView.doubleTapToZoomEnabled = false //ダブルタップによるズームを無効
        lineChartView.scaleXEnabled = false //X軸ピンチアウトを無効
        lineChartView.scaleYEnabled = false //Y軸ピンチアウトを無効
        lineChartView.highlightPerDragEnabled = false //ドラッグによるハイライト線表示を無効
        lineChartView.highlightPerTapEnabled = false //タップによるハイライト線表示を無効
        
        return lineChartView
    }
    
    func updateUIView(_ uiView: LineChartView, context: Context) {
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
        for day in (0..<dayCount) {
            let achievedYmd = showYear * 10000 + showMonth * 100 + day + 1
            let realm = Todo.customRealm()
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
        
        //折れ線データを生成
        data.append(dataSet)
        data.setDrawValues(false) //折れ線グラフのデータ値非表示
        
        //チャートにデータをセット!
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
