//
//  Meet_Widget.swift
//  Meet_Widget
//
//  Created by MEGA_Mac on 2024/05/29.
//

import WidgetKit
import SwiftUI

import Core

struct CalculateProvider: TimelineProvider {
    func placeholder(in context: Context) -> CalculateEntry {
        CalculateEntry(date: Date(), count: WidgetHelper().load())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (CalculateEntry) -> Void) {
        let entry = CalculateEntry(date: Date(), count: WidgetHelper().load())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<CalculateEntry>) -> Void) {
        var entries: [CalculateEntry] = []
        let currentDate = Date()
        let entry = CalculateEntry(date: currentDate, count: WidgetHelper().load())
        entries.append(entry)
        completion(Timeline(entries: entries, policy: .atEnd))
    }
}

struct CalculateEntry: TimelineEntry {
    let date: Date
    let count: Int
}

struct CalculateEntryView : View {
    var entry: CalculateProvider.Entry
    
    var body: some View {
        VStack {
            Text("\(entry.count)")
        }
    }
}

struct CalculateWidget: Widget {
    let kind: String = "CalculateWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CalculateProvider()) { entry in
            CalculateEntryView(entry: entry)
                .containerBackground(.white, for: .widget)
        }
        .supportedFamilies([.systemSmall, .systemMedium])
        .configurationDisplayName("카운트 위젯")
        .description("앱에서 증가 감소한 숫자를 보여주는 위젯입니다.")
    }
}
