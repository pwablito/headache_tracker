//
//  HeadacheView.swift
//  Headache Tracker
//
//  Created by Paul Spencer on 7/21/21.
//

import Foundation
import SwiftUI

struct HeadacheView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var headache: Headache
    @State var showEditSheet: Bool = false
    
    func format_date_time(date: Date?) -> String {
        if date == nil {
            return "Unknown"
        }
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date!)
    }

    var body: some View {
        List {
            Text("Start: \(format_date_time(date: headache.start_time))")
            Text("End: \(format_date_time(date: headache.end_time))")
            Text("Severity: \(headache.severity)")
            Text("Medication: " + (headache.medication ?? "None"))
            Text("Notes: " + (headache.notes ?? "None"))
            Text("Sleep: \(headache.sleep_hours) hours")
            Text("Stress level: \(headache.stress_level)")
            Text("Water consumption: \(headache.water_consumption) fl. oz.")
        }
        .navigationTitle("View Headache")
        .navigationBarItems(
            trailing: Button(
                action: {
                    self.showEditSheet = true
                },
                label: { Text("Edit") }
            )
        )
        .sheet(isPresented: $showEditSheet, onDismiss: {
            presentationMode.wrappedValue.dismiss()
        }) {
            EditSheet(
                headache: headache,
                severity: Int(headache.severity),
                stress_level: Int(headache.stress_level),
                notes: headache.notes ?? "",
                medication: headache.medication ?? "",
                start_time: headache.start_time ?? Date(),
                end_time: headache.end_time ?? Date(),
                ongoing: (headache.end_time == nil),
                water_consumption: String(headache.water_consumption),
                sleep_hours: Int(headache.sleep_hours)
            )
        }
    }
}
