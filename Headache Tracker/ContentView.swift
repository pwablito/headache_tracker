//
//  ContentView.swift
//  Headache Tracker
//
//  Created by Paul Spencer on 7/19/21.
//
import SwiftUI
import CoreData

struct ContentView: View {

    var body: some View {
        TabView {
            HeadachesView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Headaches")
                }
            DataView()
                .tabItem {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    Text("Trends")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
