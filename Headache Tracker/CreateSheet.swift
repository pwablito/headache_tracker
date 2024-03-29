//
//  CreateSheet.swift
//  Headache Tracker
//
//  Created by Paul Spencer on 7/19/21.
//

import SwiftUI
import Combine

struct CreateSheet: View {
    
    // For saving objects
    @Environment(\.managedObjectContext) private var viewContext
    
    // For closing the sheet
    @Environment(\.presentationMode) var presentationMode
    
    @State var severity: Int = 1
    @State var stress_level: Int = 1
    @State var notes: String = ""
    @State var medication: String = ""
    @State var start_time: Date = Date()
    @State var end_time: Date = Date()
    @State var ongoing: Bool = true
    @State var water_consumption: String = ""
    @State var sleep_hours: Int = 0

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
            .navigationTitle("New Headache")
            .navigationBarItems(
                leading: Button(
                    action: {
                        close()
                    },
                    label: { Text("Cancel") }
                ),
                trailing: Button(
                    action: {
                        let new_headache = Headache(context: viewContext)
                        new_headache.start_time = start_time
                        if !ongoing {
                            new_headache.end_time = end_time
                        }
                        else {
                            new_headache.end_time = nil
                        }
                        new_headache.severity = Int64(severity)
                        new_headache.medication = medication
                        new_headache.notes = notes
                        new_headache.id = UUID()
                        new_headache.stress_level = Int64(stress_level)
                        new_headache.water_consumption = Int64(water_consumption) ?? 0
                        new_headache.sleep_hours = Int64(sleep_hours)
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
