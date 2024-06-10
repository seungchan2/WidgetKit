//
//  ImageWidget.swift
//  Meet_WidgetExtension
//
//  Created by MEGA_Mac on 2024/05/30.
//

import Foundation

import WidgetKit
import SwiftUI

import Core

struct DogImageProvider: TimelineProvider {
    // MARK: 특정 내용이 없는 시각적 표현
    func placeholder(in context: Context) -> DogImageEntry {
        DogImageEntry(date: Date(), image: WidgetHelper().loadImage() ?? UIImage())
    }
    
    // MARK: 위젯 갤러리에서 보여질 부분
    func getSnapshot(in context: Context, completion: @escaping (DogImageEntry) -> Void) {
        let entry = DogImageEntry(date: Date(), image: WidgetHelper().loadImage() ?? UIImage())
        
        completion(entry)
    }
    
    // MARK: 현재 시간과 위젯을 업데이트
    /*
     해당 앱에서는 시간에 따라 이미지가 변하는 것이 아니라,
     사용자가 fetchButton을 클릭하면 reload 되기 때문에 Time을 업데이트하는 코드 제거
     */
    func getTimeline(in context: Context, completion: @escaping (Timeline<DogImageEntry>) -> Void) {
        var entries: [DogImageEntry] = []
        let currentDate = Date()
        let entry = DogImageEntry(date: currentDate, image: WidgetHelper().loadImage() ?? UIImage())
        entries.append(entry)
        completion(Timeline(entries: entries, policy: .atEnd))
    }
}

// MARK: Widget에서 사용하는 데이터 구조체
/*
 date -> 필수
 나머지는 필요한 것에 따라 정의해서 사용
 */
struct DogImageEntry: TimelineEntry {
    let date: Date
    let image: UIImage?
    let urlScheme: String = "meetWidget://image"
}

// MARK: Widget에서 보여지는 View
struct DogImageWidgetEntryView : View {
    var entry: DogImageProvider.Entry
    
    /*
     현재는 .widgetURL()을 통해 고정된 url로 이동하게끔 처리하고 있지만,
     추후에 두 개 이상의 버튼에서 각각 url 처리를 해줘야 할 때는 Link(destination) 사용 및 SwiftUI ForEach (UI)
     */
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

// MARK: WidgetConfiguration 정의
struct DogImageWidget: Widget {
    
    let kind: String = "DogImageWidget"
    /*
     kind -> 고유 식별값
     StaticConfiguration -> 사용자 편집 불가 위젯
     supportedFamilies -> 위젯 종류
     configurationDisplayName -> 위젯 갤러리에 보여질 위젯 이름
     description -> 위젯 갤러리에 보여질 위젯 설명
     contentMarginsDisabled -> 위젯 테두리 마진 제거
     */
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
