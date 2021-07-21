//
//  HeadachesView.swift
//  Headache Tracker
//
//  Created by Paul Spencer on 7/19/21.
//

import SwiftUI
import CoreData
import Foundation


struct HeadachesView: View {
    
    @State var showCreateSheet = false
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(entity: Headache.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Headache.start_time, ascending: true)])
    
    var headaches: FetchedResults<Headache>
    
    func format_date(date: Date?) -> String {
        if date == nil {
            return "Unknown"
        }
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date!)
    }

    var body: some View {
        NavigationView {
            List {
                ForEach (headaches) { headache in
                    NavigationLink(destination: HeadacheView(headache: headache)) {
                        HStack {
                            Text("Start: \(format_date(date: headache.start_time!))")
                            if headache.end_time != nil {
                                let diffComponents = Calendar.current.dateComponents([.hour, .minute], from: headache.start_time!, to: headache.end_time!)
                                    let hours = diffComponents.hour
                                    let minutes = diffComponents.minute
                                    let duration = Double(hours ?? 0) + (Double(minutes ?? 0) / 60.0)
                                    Text("\(duration, specifier: "%.2f") hours")
                            } else {
                                Text("Ongoing")
                                    .foregroundColor(Color.red)
                            }
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
