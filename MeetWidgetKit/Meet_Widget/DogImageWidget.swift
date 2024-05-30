//
//  ImageWidget.swift
//  Meet_WidgetExtension
//
//  Created by MEGA_Mac on 2024/05/30.
//

import Foundation

import WidgetKit
import SwiftUI

struct DogImageProvider: TimelineProvider {
    func placeholder(in context: Context) -> DogImageEntry {
        DogImageEntry(date: Date(), image: WidgetHelper().loadImage() ?? UIImage())
    }
    func getSnapshot(in context: Context, completion: @escaping (DogImageEntry) -> Void) {
        let entry = DogImageEntry(date: Date(), image: WidgetHelper().loadImage() ?? UIImage())
        
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<DogImageEntry>) -> Void) {
        var entries: [DogImageEntry] = []
        let currentDate = Date()
        let entry = DogImageEntry(date: currentDate, image: WidgetHelper().loadImage() ?? UIImage())
        entries.append(entry)
        completion(Timeline(entries: entries, policy: .atEnd))
    }
}

struct DogImageEntry: TimelineEntry {
    let date: Date
    let image: UIImage?
    let urlScheme: String = "meetWidget://image"
}

struct DogImageWidgetEntryView : View {
    var entry: DogImageProvider.Entry
    
    var body: some View {
        VStack {
            if let image = entry.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        }
        .widgetURL(URL(string: entry.urlScheme))
    }
}


struct DogImageWidget: Widget {
    let kind: String = "DogImageWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: DogImageProvider()) { entry in
            DogImageWidgetEntryView(entry: entry)
                .containerBackground(.white, for: .widget)
        }
        .supportedFamilies([.systemSmall, .systemMedium])
        .configurationDisplayName("강아지 위젯")
        .description("앱에서 요청한 강아지 이미지를 보여주는 위젯입니다.")
        .contentMarginsDisabled()
    }
}
