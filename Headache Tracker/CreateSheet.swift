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
    @State var notes: String = ""
    @State var medication: String = ""
    @State var start_time: Date = Date()
    @State var end_time: Date = Date()
    @State var ongoing: Bool = true

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
                        new_headache.ongoing = ongoing
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
                
                    },
                    label: { Text("Done") }
                )
            )
        }
    }
}
