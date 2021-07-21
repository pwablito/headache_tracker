//
//  HeadacheView.swift
//  Headache Tracker
//
//  Created by Paul Spencer on 7/21/21.
//

import Foundation
import SwiftUI

struct HeadacheView: View {
    
    var headache: Headache
    
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
                    print("Open edit sheet")
                },
                label: { Text("Edit") }
            )
        )
    }
}
