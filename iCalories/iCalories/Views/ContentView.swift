//
//  ContentView.swift
//  iCalories
//
//  Created by Rutuja Vetal on 15/04/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var food: FetchedResults<Food>
    
    @State private var showingAddFood = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("\(Int(totalCaloriesToday())) kcal(Today)")
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                List {
                    ForEach(food) { food in
                        NavigationLink(destination: EditFoodView(food: food)){
                            HStack {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(food.name ?? "")
                                        .bold()
                                    Text("\(Int(food.calories))") +
                                    Text(" calories").foregroundColor(.red)
                                }
                                Spacer()
                                Text(calcTimeSince(date: food.date!))
                                    .foregroundColor(.gray)
                                    .italic()
                            }
                        }
                    }
                    .onDelete(perform: deleteFood)
                }
                .listStyle(.plain)
            }
            .navigationTitle("iCalories")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddFood.toggle()
                    } label: {
                        Label("Add food", systemImage: "plus.circle")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $showingAddFood) {
                AddFoodView()
            }
        }
        .navigationViewStyle(.stack)
    }
    private func deleteFood(offsets: IndexSet) {
        withAnimation {
            offsets.map { food[$0] }.forEach(managedObjContext.delete)
            DataController().save(context: managedObjContext)
        }
    }
    
    private func totalCaloriesToday() -> Double {
        var caloriesToday: Double = 0
        for item in food {
            if Calendar.current.isDateInToday(item.date!) {
                caloriesToday += item.calories
            }
        }
        return caloriesToday
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
