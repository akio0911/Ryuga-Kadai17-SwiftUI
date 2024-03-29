//
//  ContentView.swift
//  Kadai17-SwiftUI
//
//  Created by Ryuga on 2023/04/22.
//

import SwiftUI

struct Fruit: Identifiable, Equatable {
    let id = UUID()
    var name: String
    var isChecked: Bool
}

struct ContentView: View {
    @State private var fruits = [
        Fruit(name: "りんご", isChecked: false),
        Fruit(name: "みかん", isChecked: true),
        Fruit(name: "バナナ", isChecked: false),
        Fruit(name: "パイナップル", isChecked: true)
    ]

    @State private var editMode: AddItemView.Mode?

    var body: some View {
        NavigationView {
            List {
                ForEach(fruits) { fruit in
                    ZStack {
                        HStack{
                            Image(systemName: "checkmark")
                                .foregroundColor(fruit.isChecked ? Color.orange : Color.white)
                            Spacer().frame(width: 15)
                            Text(fruit.name)
                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if let index = fruits.firstIndex(of: fruit) {
                                fruits[index].isChecked.toggle()
                            }
                        }
                        HStack {
                            Spacer()
                            Image(systemName: "info.circle")
                                .foregroundColor(Color.blue)
                        }
                        .onTapGesture {
                            if let index = fruits.firstIndex(of: fruit) {
                                editMode = .update(
                                    fruit: fruits[index],
                                    didSave: { updatedFruit in
                                        if let index = fruits.firstIndex(of: fruit) {
                                            fruits[index] = updatedFruit
                                        }
                                        editMode = nil
                                    },
                                    didCancel: {
                                        editMode = nil
                                    }
                                )
                            }
                        }
                    }
                }
                .onDelete { (offsets) in
                    self.fruits.remove(atOffsets: offsets)
                }
            }
            .listStyle(.plain)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        editMode = .create(
                            didSave: { newFruit in
                                fruits.append(newFruit)
                                editMode = nil
                            },
                            didCancel: {
                                editMode = nil
                            }
                        )
                    }) {
                        Image(systemName: "plus")
                    }
                    .fullScreenCover(item: $editMode) { mode in
                        AddItemView(mode: mode)
                    }
                }
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
