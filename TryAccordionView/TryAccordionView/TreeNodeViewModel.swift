//
//  TreeNodeViewModel.swift
//  TryAccordionView
//
//  Created by rifumi on 2023/07/19.
//

import Foundation

class NodeViewModel: ObservableObject, Identifiable {
    let id = UUID()
    @Published var name: String
    @Published var isExpanded: Bool
    @Published var children: [NodeViewModel]
    
    init(nodeName: String, isExpanded: Bool = false, children: [NodeViewModel]) {
        self.name = nodeName
        self.isExpanded = isExpanded
        self.children = children
    }
    
    func addNode(node: NodeViewModel) {
        self.children.append(node)
    }
    
    func addNode(withName name: String) {
        let newChild = NodeViewModel(nodeName: name, children: [])
        self.children.append(newChild)
    }
    
    func deleteNode(item: NodeViewModel) {
        if let itemIndex = children.firstIndex(where: { $0.id==item.id }) {
            let mutableItem = children[itemIndex]
            mutableItem.children.remove(at: itemIndex)
            children[itemIndex] = mutableItem
        }
    }
    
    func getNode(withCondition condition: (NodeViewModel) -> Bool) -> NodeViewModel? {
        if condition(self) {
            return self
        }

        if let item = children.first(where: condition) {
            return item
        }

        return nil
    }

    func getNode(forName name: String) -> NodeViewModel? {
        return getNode { $0.name == name }
    }

    func getNode(matching pattern: String) -> NodeViewModel? {
        return getNode { $0.name.contains(pattern) }
    }
    
    func getNodes(withCondition condition: (NodeViewModel) -> Bool) -> [NodeViewModel] {
        var result = [NodeViewModel]()
        if condition(self) {
            result.append(self)
        }
        
        result.append(contentsOf: children.filter({condition($0)}))
        return result
    }
    
    func getNodes(forName name: String) -> [NodeViewModel] {
        return getNodes(withCondition: {$0.name==name})
    }
    
    func getNodes(matching name: String) -> [NodeViewModel] {
        return getNodes(withCondition: {$0.name.contains(name)})
    }
}

class RootViewModel: ObservableObject {
    @Published var nodes: [NodeViewModel] = []
    
    func addNode(withName name: String) {
        let newChild = NodeViewModel(nodeName: name, children: [])
        self.nodes.append(newChild)
    }
}
