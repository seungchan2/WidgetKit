//
//  Meet_WidgetBundle.swift
//  Meet_Widget
//
//  Created by MEGA_Mac on 2024/05/29.
//

import WidgetKit
import SwiftUI

// MARK: 사용할 위젯 등록
@main
struct Meet_WidgetBundle: WidgetBundle {
    var body: some Widget {
        CalculateWidget()
        DogImageWidget()
    }
}
