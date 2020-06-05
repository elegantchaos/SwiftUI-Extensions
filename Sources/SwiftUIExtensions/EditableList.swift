// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 05/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI

public class EditContext: ObservableObject {
    @Published var editing: Bool = false
}


public protocol EditableModel: ObservableObject {
    associatedtype Item: Identifiable
    associatedtype Items: RandomAccessCollection
    var items: Items { get }
    func delete(item: Item)
    func delete(at offsets: IndexSet)
    func move(from: IndexSet, to: Int)
}

public struct EditingView<Content>: View where Content: View {
    @State var editContext = EditContext()
    let content: () -> Content
    
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    public var body: some View {
        content()
            .environmentObject(editContext)
            .bindEditing(to: $editContext.editing)
    }

}

public struct EditableRowView<Model, Content>: View where Content: View, Model: EditableModel {
    let item: Model.Item
    let content: () -> Content
    @EnvironmentObject var editContext: EditContext
    @EnvironmentObject var model: Model

    public init(item: Model.Item, model: Model, @ViewBuilder content: @escaping () -> Content) {
        self.item = item
        self.content = content
    }

    public var body: some View {
        return HStack {
            if editContext.editing {
                SystemImage(.rowHandle)
                Button(action: { self.model.delete(item: self.item) })  {
                    SystemImage(.rowDelete)
                        .foregroundColor(Color.red)
                }.buttonStyle(BorderlessButtonStyle())
            }

            content()
        }
    }
}

public struct EditButton<Content>: View where Content: View {
    @EnvironmentObject var editContext: EditContext
    let content: () -> Content
    
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    public var body: some View {
        Button(action: {
            self.editContext.editing = !self.editContext.editing
        }) {
            content()
        }
    }
}

public struct EditableList<ID, Content, Model>: View where ID == Model.Item.ID, Content : View, Model: EditableModel, Model.Items.Element == Model.Item {
    @EnvironmentObject var editContext: EditContext
    let model: Model
    let content: (Model.Item) -> Content
    
    public init(model: Model, @ViewBuilder content: @escaping (Model.Item) -> Content) {
        self.content = content
        self.model = model
    }

    public var body: some View {
        List {
            ForEach(model.items) { item in
                HStack {
                    if self.editContext.editing {
                        SystemImage(.rowHandle)
                        Button(action: { self.model.delete(item: item) })  {
                            SystemImage(.rowDelete)
                                .foregroundColor(Color.red)
                        }.buttonStyle(BorderlessButtonStyle())
                    }
                    
                    self.content(item)
                }
            }
                .onDelete(perform: { at in self.model.delete(at: at) })
                .onMove(perform: editContext.editing ? { from, to in self.model.move(from: from, to: to)} : nil)
        }
    }
}

