//
//  Meet_Widget.swift
//  Meet_Widget
//
//  Created by MEGA_Mac on 2024/05/29.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), count: WidgetHelper().load(kind: .increase))
    }
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), count: WidgetHelper().load(kind: .increase))

        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        var entries: [SimpleEntry] = []
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, count: WidgetHelper().load(kind: .increase))
            print(entry)
            entries.append(entry)
        }

        completion(Timeline(entries: entries, policy: .atEnd))
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let count: Int
//    let configuration: ConfigurationAppIntent
}

struct Meet_WidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("\(entry.count)")
        }
        
    }
}


struct Meet_Widget: Widget {
    let kind: String = "increase"

    var body: some WidgetConfiguration {
//        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
//            Meet_WidgetEntryView(entry: entry)
//                .containerBackground(.fill.tertiary, for: .widget)
//        }
        
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            Meet_WidgetEntryView(entry: entry)
                .containerBackground(.white, for: .widget)
        }
        .supportedFamilies([.systemSmall, .systemMedium])
        .configurationDisplayName("ㅎㅎ")
        .description("크크크")
    }
}
//
//extension ConfigurationAppIntent {
//    fileprivate static var smiley: ConfigurationAppIntent {
//        let intent = ConfigurationAppIntent()
//        intent.favoriteEmoji = "😀"
//        return intent
//    }
//    
//    fileprivate static var starEyes: ConfigurationAppIntent {
//        let intent = ConfigurationAppIntent()
//        intent.favoriteEmoji = "🤩"
//        return intent
//    }
//}

//#Preview(as: .systemSmall) {
//    Meet_Widget()
//} timeline: {
//    SimpleEntry(date: .now, configuration: .smiley)
//    SimpleEntry(date: .now, configuration: .starEyes)
//}
