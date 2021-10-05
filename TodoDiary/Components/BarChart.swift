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
    
    func makeUIView(context: Context) -> BarChartView {
        let barChartView = BarChartView()
        return barChartView
    }
    
    func updateUIView(_ uiView: BarChartView, context: Context) {
        let rawData: [Int] = [20, 50, 70, 30, 60, 90, 40]
        let entries = rawData.enumerated().map { BarChartDataEntry(x: Double($0.offset), y: Double($0.element)) }
        let dataSet = BarChartDataSet(entries: entries)
        let data = BarChartData(dataSet: dataSet)
        uiView.data = data
    }
        
}
