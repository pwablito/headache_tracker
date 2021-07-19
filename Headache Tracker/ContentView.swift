//
//  ContentView.swift
//  Headache Tracker
//
//  Created by Paul Spencer on 7/19/21.
//
import SwiftUI
import CoreData

struct ContentView: View {
    
    @State var showCreateSheet = false
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(entity: Headache.entity(), sortDescriptors: [])
    
    var headaches: FetchedResults<Headache>
    
    func format_date(date: Date?) -> String {
        if date == nil {
            return "Unknown"
        }
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date!)
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach (headaches) { headache in
                    NavigationLink(
                        destination: List {
                            Text("Start: \(format_date(date: headache.start_time))")
                            Text("End: \(format_date(date: headache.end_time))")
                            Text("Severity: \(headache.severity)")
                            Text("Medication: " + (headache.medication ?? "None"))
                            Text("Notes: " + (headache.notes ?? "None"))
                        }
                    ) {
                        HStack {
                            Text("Start: \(format_date(date: headache.start_time!))")
                            Text("End: \(format_date(date: headache.end_time))")
                            Text("Severity: \(headache.severity)")
                        }
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        viewContext.delete(headaches[index])
                    }
                    do {
                        try viewContext.save()
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
            .navigationTitle("Headaches")
            .navigationBarItems(
                trailing: Button(
                    action: {
                        self.showCreateSheet = true
                    },
                    label: {
                        Image(systemName: "plus.circle")
                        .imageScale(.large)
                    }
                )
            )
            .sheet(isPresented: $showCreateSheet) {
                CreateSheet()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
