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
    
    //4 or 12
    var maxItemCount: Int {
        switch self.widgetFamily {
            case .systemSmall, .systemMedium: return 4
            case .systemLarge, .systemExtraLarge: return 11
            default: return 4
        }
    }
    
    var showItemCount: Int {
        if entry.todos.count > maxItemCount {
            return maxItemCount
        } else {
            return entry.todos.count
        }
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                
                // Todos not limited
                ForEach(0 ..< showItemCount) { index in
                    Text(entry.todos[index].content)
                        .font(.subheadline)
                        .fontWeight(entry.todos[index].isPinned ? .bold : .regular)
                        .lineLimit(1)
                        .padding(.bottom, 0.5)
                }
                
                // HowManyMoreテキスト
                if entry.todos.count > maxItemCount {
                    Text("\(entry.todos.count - maxItemCount) More")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
            Spacer()
        }
        .padding(10)
        .padding(.top)
    }
}

@main
struct FirstWidget: Widget {
    let kind: String = "FirstWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            FirstWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Todo list")
        .description("You can check your Todos.")
    }
}
