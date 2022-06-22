//
//  FirstView.swift
//  TodoDiary
//
//  Created by Yu on 2021/09/15.
//

import SwiftUI
import RealmSwift

struct FirstView: View {
    
    @ObservedResults(Todo.self, filter: NSPredicate(format: "isPinned == true && isAchieved == false"), sortDescriptor: SortDescriptor(keyPath: "order")) var pinnedTodos
    @ObservedResults(Todo.self, filter: NSPredicate(format: "isPinned == false && isAchieved == false"), sortDescriptor: SortDescriptor(keyPath: "order")) var unpinnedTodos
    
    @State var isShowCreateSheet = false
    @State var isShowEditSheet = false
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                                        
                    if pinnedTodos.count != 0 {
                        Section(header: Text("pinned")) {
                            ForEach(pinnedTodos) { todo in
                                TodoRow(todo: todo)
                            }
                            .onMove {sourceIndexSet, destination in
                                Todo.sortTodos(todos: pinnedTodos, sourceIndexSet: sourceIndexSet, destination: destination)
                            }
                        }
                    }
                    
                    if unpinnedTodos.count != 0 {
                        Section(header: pinnedTodos.count == 0 ? nil : Text("others")) {
                            ForEach(unpinnedTodos) { todo in
                                TodoRow(todo: todo)
                            }
                            .onMove {sourceIndexSet, destination in
                                Todo.sortTodos(todos: unpinnedTodos, sourceIndexSet: sourceIndexSet, destination: destination)
                            }
                        }
                    }
                    
                }
                .listStyle(InsetGroupedListStyle())
                .animation(.default, value: pinnedTodos)
                .animation(.default, value: unpinnedTodos)
                
                if pinnedTodos.count == 0 && unpinnedTodos.count == 0 {
                    Text("there_is_no_todo_yet")
                        .foregroundColor(.secondary)
                }
            }
            
            .sheet(isPresented: $isShowCreateSheet) {
                CreateView()
            }
            
            .navigationTitle("todos")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    CustomEditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isShowCreateSheet.toggle()
                    }){
                        Image(systemName: "plus.circle.fill")
                        Text("new_todo")
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func reloadView() {
        //TODO: 画面の一番上までスクロールし、リストを更新する
        print("reload FirstView")
    }
}
