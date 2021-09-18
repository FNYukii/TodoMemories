//
//  LineChart.swift
//  TodoDiary
//
//  Created by Yu on 2021/09/19.
//

import Charts
import SwiftUI

struct LineChart : UIViewRepresentable {
    
    func makeUIView(context: Context) -> LineChartView {
        //折れ線用のデータ
        let lineChartEntry : [ChartDataEntry] = [
            ChartDataEntry(x: 0, y: 3),
            ChartDataEntry(x: 1, y: 5),
            ChartDataEntry(x: 2, y: 4),
            ChartDataEntry(x: 3, y: 8),
            ChartDataEntry(x: 4, y: 2),
            ChartDataEntry(x: 5, y: 3),
        ]
        //折れ線を生成
        let data = LineChartData()
        let dataSet = LineChartDataSet(entries: lineChartEntry)
        //折れ線のスタイルをカスタマイズ
        dataSet.drawCirclesEnabled = false
        dataSet.setColor(UIColor.systemBlue)
        //チャートを生成して折れ線データをセット
        let lineChartView = LineChartView()
        data.append(dataSet)
        lineChartView.data = data
        //チャートのスタイルをカスタマイズ
        lineChartView.data!.setDrawValues(false)
        lineChartView.rightAxis.enabled = false
        
        return lineChartView
    }
    
    func updateUIView(_ uiView: LineChartView, context: Context) {
        //
    }
    
}
