//
//  FirstWidget.swift
//  FirstWidget
//
//  Created by Yu on 2021/09/20.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), todoStrs: ["Apple", "Orange"])
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), todoStrs: ["Strawberry", "Melon"])
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        //全てのTodoを取得
        let todoStrs = ["Blueberry", "Yucca"]
        
        //Entryにデータをセット
        var entries: [SimpleEntry] = []
        let entry = SimpleEntry(date: Date(), todoStrs: todoStrs)
        entries.append(entry)

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let todoStrs: [String]
}

struct FirstWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            ForEach(0..<entry.todoStrs.count) { index in
                Text("\(entry.todoStrs[index])")
            }
            Spacer()
        }
        .font(.subheadline)
    }
}

@main
struct FirstWidget: Widget {
    let kind: String = "FirstWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            FirstWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}
