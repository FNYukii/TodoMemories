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
        SimpleEntry(date: Date(), todoContents: ["買い物に行く", "宿題をする"], isPinned: false)
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), todoContents: ["買い物に行く", "宿題をする"], isPinned: false)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
                
        let pinnedTodos = Todo.pinnedTodos()
        let unpinnedTodos = Todo.unpinnedTodos()
        var todos = Todo.noRecord()
        var isPinned = false
        if pinnedTodos.count > 0 {
            todos = pinnedTodos
            isPinned = true
        } else {
            todos = unpinnedTodos
        }
        
        var todoContents: [String] = []
        for todo in todos {
            todoContents.append(todo.content)
        }
        
        //Entryにデータをセット
        var entries: [SimpleEntry] = []
        let entry = SimpleEntry(date: Date(), todoContents: todoContents, isPinned: isPinned)
        entries.append(entry)

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let todoContents: [String]
    let isPinned: Bool
}

struct FirstWidgetEntryView : View {
    
    //Todoのデータ
    var entry: Provider.Entry
    
    //Todoテキストの行の高さ
    let lineHeight: CGFloat = 23
    
    var itemCount = 0

    var body: some View {
        ZStack {
            
            Color("background")
            
            VStack(alignment: .leading) {
                
                //ラベル
                ZStack(alignment: .leading) {
                    Color.red
                        .frame(height: 30)
                    Text(entry.isPinned ? "固定済み" : "Todo")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .padding(.leading)
                }
                
                //固定済みTodoが5つ未満
                if entry.todoContents.count < 5 {
                    ForEach(0..<entry.todoContents.count) { index in
                        Text("\(entry.todoContents[index])")
                            .font(.subheadline)
                            .frame(height: lineHeight)
                            .padding(.leading)
                    }
                }
                
                //固定済みTodoが5つ以上
                if entry.todoContents.count > 4 {
                    ForEach(0..<4) { index in
                        Text("\(entry.todoContents[index])")
                            .font(.subheadline)
                            .frame(height: lineHeight)
                            .padding(.leading)
                    }
                }
                
                
                if entry.todoContents.count > 4 {
                    Text("\(entry.todoContents.count - 4) More")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.leading)
                }
                
                Spacer()
                
            }
            
        }
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
