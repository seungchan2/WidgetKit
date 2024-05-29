//
//  MeetWidget_LiveActivity.swift
//  MeetWidget`
//
//  Created by MEGA_Mac on 2024/05/29.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct MeetWidget_Attributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct MeetWidget_LiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MeetWidget_Attributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension MeetWidget_Attributes {
    fileprivate static var preview: MeetWidget_Attributes {
        MeetWidget_Attributes(name: "World")
    }
}

extension MeetWidget_Attributes.ContentState {
    fileprivate static var smiley: MeetWidget_Attributes.ContentState {
        MeetWidget_Attributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: MeetWidget_Attributes.ContentState {
         MeetWidget_Attributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: MeetWidget_Attributes.preview) {
   MeetWidget_LiveActivity()
} contentStates: {
    MeetWidget_Attributes.ContentState.smiley
    MeetWidget_Attributes.ContentState.starEyes
}
