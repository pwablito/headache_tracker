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
    
    @State var severity = 1
    @State var notes = ""
    @State var medication = ""
    @State var start_time = Date()
    @State var end_time = Date()
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
                    DatePicker(
                        selection: $end_time,
                        displayedComponents: [.date, .hourAndMinute]
                    ) {
                        Text("End time")
                    }
                    Stepper("Severity: \(severity) ", value: $severity, in: 1...10)
                }
                
                Section(header: Text("Additional Information")) {
                    TextField("Medication", text: $medication)
                    TextField("Notes", text: $notes)
                }
            }
            .navigationTitle("Add Order")
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
                        new_headache.end_time = end_time
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
