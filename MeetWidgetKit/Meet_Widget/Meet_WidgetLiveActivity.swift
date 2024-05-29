//
//  Meet_WidgetLiveActivity.swift
//  Meet_Widget
//
//  Created by MEGA_Mac on 2024/05/29.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct Meet_WidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct Meet_WidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: Meet_WidgetAttributes.self) { context in
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

extension Meet_WidgetAttributes {
    fileprivate static var preview: Meet_WidgetAttributes {
        Meet_WidgetAttributes(name: "World")
    }
}

extension Meet_WidgetAttributes.ContentState {
    fileprivate static var smiley: Meet_WidgetAttributes.ContentState {
        Meet_WidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: Meet_WidgetAttributes.ContentState {
         Meet_WidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: Meet_WidgetAttributes.preview) {
   Meet_WidgetLiveActivity()
} contentStates: {
    Meet_WidgetAttributes.ContentState.smiley
    Meet_WidgetAttributes.ContentState.starEyes
}
