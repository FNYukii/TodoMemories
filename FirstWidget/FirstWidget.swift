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
    
    //Widgetの大きさ
    @Environment(\.widgetFamily) var widgetFamily
    
    //Todoのデータ
    var entry: Provider.Entry
    
    //4 or 12
    var maxItemCount: Int {
        switch self.widgetFamily {
            case .systemSmall: return 4
            case .systemMedium: return 4
            case .systemLarge: return 12
            case .systemExtraLarge: return 12
            default: return 4
        }
    }
    
    var showItemCount: Int {
        if entry.todoContents.count > maxItemCount {
            return maxItemCount
        } else {
            return entry.todoContents.count
        }
    }

    var body: some View {
        ZStack {
            
            Color("background")
            
            VStack(alignment: .leading) {
                
                //ラベル
                ZStack(alignment: .leading) {
                    Color.red
                        .frame(height: 25)
                    Text(entry.isPinned ? "固定済み" : "Todo")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .padding(.leading)
                }
                
                //Todo一覧
                ForEach(0..<showItemCount) { index in
                    Text("\(entry.todoContents[index])")
                        .font(.subheadline)
                        .frame(height: 23)
                        .padding(.leading)
                }
                
                if entry.todoContents.count > maxItemCount {
                    Text("\(entry.todoContents.count - maxItemCount) More")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .frame(height: 23)
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
