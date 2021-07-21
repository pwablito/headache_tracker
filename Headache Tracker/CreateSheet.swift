//
//  CreateSheet.swift
//  Headache Tracker
//
//  Created by Paul Spencer on 7/19/21.
//

import SwiftUI

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
    @State var water_consumption: Int = 0

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
                    Stepper("Water consumption: \(water_consumption)", value: $water_consumption, in: 0...10000)
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
                        print(new_headache)
                        do {
                            try viewContext.save()
                            close()
                        } catch {
                            print(error.localizedDescription)
                        }
                        new_headache.stress_level = Int64(stress_level)
                        new_headache.water_consumption = Int64(water_consumption)
                
                    },
                    label: { Text("Done") }
                )
            )
        }
    }
}
