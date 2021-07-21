//
//  HeadacheView.swift
//  Headache Tracker
//
//  Created by Paul Spencer on 7/21/21.
//

import SwiftUI
import CoreData
import Combine

struct EditSheet: View {
    
    // For saving objects
    @Environment(\.managedObjectContext) var viewContext
    
    // For closing the sheet
    @Environment(\.presentationMode) var presentationMode
    
    var headache: Headache

    @State var severity: Int
    @State var stress_level: Int
    @State var notes: String
    @State var medication: String
    @State var start_time: Date
    @State var end_time: Date
    @State var ongoing: Bool
    @State var water_consumption: String
    @State var sleep_hours: Int
    
    func close() {
        presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Headache logistics")) {
                    DatePicker(
                        selection: $start_time,
                        displayedComponents: [.date, .hourAndMinute]
                    ) {
                        Text("Start time")
                    }
                    Toggle(isOn: $ongoing) {
                        Text("Ongoing")
                    }
                    if (!ongoing) {
                        DatePicker(
                            selection: $end_time,
                            displayedComponents: [.date, .hourAndMinute]
                        ) {
                            Text("End time")
                        }
                    }
                    Stepper("Severity: \(severity) ", value: $severity, in: 1...10)
                }
                
                Section(header: Text("Additional Information")) {
                    Stepper("Stress level: \(stress_level)", value: $stress_level, in: 1...10)
                    TextField("Water Consumption (fl. oz.)", text: $water_consumption)
                        .keyboardType(.numberPad)
                        .onReceive(Just(water_consumption)) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue {
                                self.water_consumption = filtered
                            }
                        }
                    Stepper("Sleep hours: \(sleep_hours)", value: $sleep_hours, in: 0...24)
                    TextField("Medication", text: $medication)
                    TextField("Notes", text: $notes)
                }
            }
            .navigationTitle("Edit Headache")
            .navigationBarItems(
                leading: Button(
                    action: {
                        close()
                    },
                    label: { Text("Cancel") }
                ),
                trailing: Button(
                    action: {
                        headache.start_time = start_time
                        if !ongoing {
                            headache.end_time = end_time
                        }
                        else {
                            headache.end_time = nil
                        }
                        headache.severity = Int64(severity)
                        headache.medication = medication
                        headache.notes = notes
                        headache.stress_level = Int64(stress_level)
                        headache.water_consumption = Int64(water_consumption) ?? 0
                        headache.sleep_hours = Int64(sleep_hours)
                        do {
                            try viewContext.save()
                            close()
                        } catch {
                            print(error.localizedDescription)
                        }
                
                    },
                    label: { Text("Done") }
                )
            )
        }
    }
}
