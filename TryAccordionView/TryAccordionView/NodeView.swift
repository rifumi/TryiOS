//
//  NodeView.swift
//  TryAccordionView
//
//  Created by rifumi on 2023/07/19.
//

import SwiftUI

struct NodeView: View {
    enum FocusField: Hashable {
      case field
    }
    var depthId: Int
    @ObservedObject var node: NodeViewModel
    @State private var newChildName = ""
    @State private var isShowingAddItem = false
    @FocusState private var isTextFieldFocused: FocusField?
    
    var body: some View {
        DisclosureGroup(isExpanded: $node.isExpanded) {
            ForEach(node.children) { child in
                NodeView(depthId: self.depthId+1, node: child)
            }
        } label: {
            let nodeTitle:String = String(repeating: "> ", count: depthId)+node.name
            Text(nodeTitle)
                .multilineTextAlignment(.leading)
            .padding()
            Button(action:{
                isShowingAddItem = true
            }) {
                Image(systemName: "plus")
            }
        }.background(.yellow)
        .sheet(isPresented: $isShowingAddItem, content: {
            VStack {
                TextField("Enter Child Name", text: $newChildName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .focused($isTextFieldFocused, equals: .field)
                    .padding()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000)) {
                            isTextFieldFocused = .field
                        }
                    }
                HStack{
                    Button("Cancel") {
                        newChildName = ""
                        isShowingAddItem = false
                    }
                    .padding()
                    Button("Add") {
                        node.addNode(withName: newChildName)
                        newChildName = ""
                        isShowingAddItem = false
                        self.node.isExpanded = true
                    }
                    .disabled(newChildName.isEmpty)
                    .padding()
                }
                Spacer()
            }
        })
    }
}

struct SheetView: View {
    @Binding var text: String
    var body: some View {
        TextField("Enter text", text: $text)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
    }
}

struct NodeView_Previews: PreviewProvider {
    static var previews: some View {
        NodeView(depthId: 0, node: NodeViewModel(nodeName: "Root", children: [
            NodeViewModel(nodeName: "1234567890", children: []),
            NodeViewModel(nodeName: "12345678901234567890", children: []),
            NodeViewModel(nodeName: "123456789012345678901234567890", children: [])
        ]))
    }
}
