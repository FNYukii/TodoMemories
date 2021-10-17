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
        SimpleEntry(date: Date(), pinnedTodoStrs: ["買い物に行く", "宿題をする"], unpinnedTodoStrs: ["洗濯物を畳む", "早く寝る"])
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), pinnedTodoStrs: ["買い物に行く", "宿題をする"], unpinnedTodoStrs: ["洗濯物を畳む", "早く寝る"])
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
    
    //Todoのデータ
    var entry: Provider.Entry
    
    //Todoテキストの行の高さ
    let lineHeight: CGFloat = 23
    
    var itemCount = 0

    var body: some View {
        ZStack {
            
            Color("background")
            
            VStack(alignment: .leading) {
                
                //固定済みラベル
                if entry.pinnedTodoStrs.count != 0 {
                    ZStack(alignment: .leading) {
                        Color.red
                            .frame(height: 30)
                        Text("固定済み")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .padding(.leading)
                    }
                }
                
                //固定済みTodoが5つ未満
                if entry.pinnedTodoStrs.count < 5 {
                    ForEach(0..<entry.pinnedTodoStrs.count) { index in
                        Text("\(entry.pinnedTodoStrs[index])")
                            .font(.subheadline)
                            .frame(height: lineHeight)
                            .padding(.leading)
                    }
                }
                
                //固定済みTodoが5つ以上
                if entry.pinnedTodoStrs.count > 4 {
                    ForEach(0..<4) { index in
                        Text("\(entry.pinnedTodoStrs[index])")
                            .font(.subheadline)
                            .frame(height: lineHeight)
                            .padding(.leading)
                    }
                }
                
                
                if entry.pinnedTodoStrs.count > 4 {
                    Text("\(entry.pinnedTodoStrs.count - 4) More")
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
