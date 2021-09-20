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
        SimpleEntry(date: Date(), pinnedTodoStrs: ["Apple", "Orange"], unpinnedTodoStrs: ["Strawberry", "melon"])
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), pinnedTodoStrs: ["Apple", "Orange"], unpinnedTodoStrs: ["Strawberry", "melon"])
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
                
        //固定済みTodoの文字列型配列を生成
        var pinnedTodoStrs: [String] = []
        let pinnedTodos = Todo.pinnedTodos()
        for pinnedTodo in pinnedTodos {
            pinnedTodoStrs.append(pinnedTodo.content)
        }
        
        //未固定Todoの文字列型配列を生成
        var unpinnedTodoStrs: [String] = []
        let unpinnedTodos = Todo.unpinnedTodos()
        for unpinnedTodo in unpinnedTodos {
            unpinnedTodoStrs.append(unpinnedTodo.content)
        }
        
        //Entryにデータをセット
        var entries: [SimpleEntry] = []
        let entry = SimpleEntry(date: Date(), pinnedTodoStrs: pinnedTodoStrs, unpinnedTodoStrs: unpinnedTodoStrs)
        entries.append(entry)

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let pinnedTodoStrs: [String]
    let unpinnedTodoStrs: [String]
}

struct FirstWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        
        HStack {
            
            VStack(alignment: .leading) {
                
                if entry.pinnedTodoStrs.count != 0 {
                    Text("固定済み")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                ForEach(0..<entry.pinnedTodoStrs.count) { index in
                    Text("\(entry.pinnedTodoStrs[index])")
                        .font(.subheadline)
                }
                
                if entry.pinnedTodoStrs.count != 0 && entry.unpinnedTodoStrs.count != 0 {
                    Text("その他")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                ForEach(0..<entry.unpinnedTodoStrs.count) { index in
                    Text("\(entry.unpinnedTodoStrs[index])")
                        .font(.subheadline)
                }
                            
            }
            
            Spacer()
            
        }
        .padding(7)
        
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
