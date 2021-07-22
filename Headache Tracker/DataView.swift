//
//  DataView.swift
//  Headache Tracker
//
//  Created by Paul Spencer on 7/19/21.
//

import Foundation
import SwiftUI
import SwiftUICharts
import CoreData

struct DataView: View {

    @FetchRequest(entity: Headache.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Headache.start_time, ascending: true)])

    var headaches: FetchedResults<Headache>

    @State private var rangeSize: Int = 31 // Start at a month

    func format_date(date: Date?) -> String {
        if date == nil {
            return "Unknown"
        }
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date!)
    }

    func format_date_time(date: Date?) -> String {
        if date == nil {
            return "Unknown"
        }
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date!)
    }

    func getData() -> LineChartData {
            
        var points: Array<LineChartDataPoint> = []
        for headache in headaches {
            if headache.start_time!.addingTimeInterval(TimeInterval(rangeSize * 24 * 60 * 60)) > Date() { // Check if in the last `rangeSize` days
                points.append(LineChartDataPoint(value: Double(headache.stress_level), xAxisLabel: format_date(date: headache.start_time), description: format_date_time(date: headache.start_time)))
            }
        }
        let data = LineDataSet(
            dataPoints: points,
            legendTitle: "Stress (1-10)",
            pointStyle: PointStyle(),
            style: LineStyle(lineColour: ColourStyle(colour: .red), lineType: .curvedLine)
        )
        
        let metadata = ChartMetadata(title: "Stress on Headache Days")
        
        let gridStyle = GridStyle(
            numberOfLines: 5,
            lineColour: Color(.lightGray).opacity(0.5),
            lineWidth: 1,
            dash: [8],
            dashPhase: 0
        )
        
        let chartStyle = LineChartStyle(
            infoBoxPlacement: .infoBox(isStatic: false),
            infoBoxBorderColour: Color.primary,
            infoBoxBorderStyle: StrokeStyle(lineWidth: 1),
            markerType: .vertical(
                attachment: .line(
                    dot: .style(DotStyle())
                )
            ),
            xAxisGridStyle: gridStyle,
            xAxisLabelPosition: .bottom,
            xAxisLabelColour: Color.primary,
            xAxisLabelsFrom: .dataPoint(rotation: .degrees(0)),
            yAxisGridStyle: gridStyle,
            yAxisLabelPosition: .leading,
            yAxisLabelColour: Color.primary,
            yAxisNumberOfLabels: 7,
            baseline: .minimumWithMaximum(of: 5000),
            globalAnimation: .easeOut(duration: 1))
        return LineChartData(dataSets: data, metadata: metadata, chartStyle: chartStyle)
    }
    
    var body: some View {
        VStack {
            Picker("", selection: $rangeSize) {
                Text("Week").tag(7)
                Text("Month").tag(31)
                Text("3 Month").tag(92)
                Text("Year").tag(365)
            }
            .pickerStyle(SegmentedPickerStyle())
            ScrollView {
                let data = getData()
                if data.dataSets.dataPoints.count < 2 {
                    Text("Not enough data")
                } else {
                LineChart(chartData: data)
                    .pointMarkers(chartData: data)
                    .touchOverlay(chartData: data, specifier: "%.0f")
                    .averageLine(chartData: data, strokeStyle: StrokeStyle(lineWidth: 3, dash: [5,10]))
                    .xAxisGrid(chartData: data)
                    .yAxisGrid(chartData: data)
                    .xAxisLabels(chartData: data)
                    .yAxisLabels(chartData: data)
                    .infoBox(chartData: data)
                    .headerBox(chartData: data)
                    .legends(chartData: data, columns: [GridItem(.flexible()), GridItem(.flexible())])
                    .id(data.id)
                    .frame(height: 400)
                }
            }
        }
        .padding()
    }
}
