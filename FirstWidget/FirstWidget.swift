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
        // Todosを取得
        var todos: [Todo] = []
        todos.append(contentsOf: Array(Todo.pinnedTodos()))
        todos.append(contentsOf: Array(Todo.unpinnedTodos()))
        
        return SimpleEntry(date: Date(), todos: todos)
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        // Todosを取得
        var todos: [Todo] = []
        todos.append(contentsOf: Array(Todo.pinnedTodos()))
        todos.append(contentsOf: Array(Todo.unpinnedTodos()))
        
        // Entryを生成
        let entry = SimpleEntry(date: Date(), todos: todos)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
                
        // Todosを取得
        var todos: [Todo] = []
        todos.append(contentsOf: Array(Todo.pinnedTodos()))
        todos.append(contentsOf: Array(Todo.unpinnedTodos()))
                
        //Entryにデータをセット
        var entries: [SimpleEntry] = []
        let entry = SimpleEntry(date: Date(), todos: todos)
        entries.append(entry)

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let todos: [Todo]
}

struct FirstWidgetEntryView : View {
    
    //Widgetの大きさ
    @Environment(\.widgetFamily) var widgetFamily
    
    //Todoのデータ
    var entry: Provider.Entry
    
//    //4 or 12
//    var maxItemCount: Int {
//        switch self.widgetFamily {
//            case .systemSmall: return 4
//            case .systemMedium: return 4
//            case .systemLarge: return 12
//            case .systemExtraLarge: return 12
//            default: return 4
//        }
//    }
    
//    var showItemCount: Int {
//        if entry.todoContents.count > maxItemCount {
//            return maxItemCount
//        } else {
//            return entry.todoContents.count
//        }
//    }

    var body: some View {
        VStack(alignment: .leading) {
            
            // Todos
            ForEach(entry.todos) { todo in
                Text(todo.content)
                    .font(.subheadline)
                    .fontWeight(todo.isPinned ? .bold : .regular)
                    .lineLimit(1)
            }
            
//                if entry.todoContents.count > maxItemCount {
//                    Text("\(entry.todoContents.count - maxItemCount) More")
//                        .font(.caption)
//                        .foregroundColor(.secondary)
//                        .frame(height: 23)
//                        .padding(.leading)
//                }
            Spacer()
        }
        .padding(6)
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
