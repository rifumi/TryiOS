//
//  ContentView.swift
//  TryAccordionView
//
//  Created by rifumi on 2023/07/17.
//

import SwiftUI

struct ContentView: View {
    enum FocusField: Hashable {
      case field
    }
    #if DEBUG
    var release = true
    #endif
    @StateObject private var rootNodes = RootViewModel()
    @State private var newChildName = ""
    @State private var isShowingAddItem = false
    @FocusState private var isTextFieldFocused: FocusField?
    
    var body: some View {
        NavigationView{
            VStack(alignment:.leading) {
                if rootNodes.nodes.isEmpty {
                    EmptyView()
                } else {
                    ForEach(rootNodes.nodes) { rootNode in
                        NodeView(depthId: 0, node: rootNode)
                    }
                    Spacer()
                }
            }
            .navigationTitle("Hierarchy")
            .navigationBarItems(trailing: Button(action: {
                isShowingAddItem = true
            }){
                Image(systemName: "plus")
            })
            .sheet(isPresented: $isShowingAddItem, content: {
                VStack {
                    TextField("Enter node name", text: $newChildName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000)) {
                                isTextFieldFocused = .field
                            }
                        }
                    HStack {
                        Button("Cancel") {
                            newChildName = ""
                            isShowingAddItem = false
                        }
                        .padding()
                        Button("Add") {
                            rootNodes.addNode(withName: newChildName)
                            newChildName = ""
                            isShowingAddItem = false
                        }
                        .padding()
                        .disabled(newChildName.isEmpty)
                    }
                    Spacer()
                }
                .padding()
            })
            .padding()
        }
        #if DEBUG
        .onAppear {
            if self.release == false {
                rootNodes.addNode(withName: "Task1")
                rootNodes.addNode(withName: "Task2")
            }
        }
        #endif
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(release: false)
    }
}
#endif
