//
//  WidgetHelper.swift
//  MeetWidgetKit
//
//  Created by MEGA_Mac on 2024/05/29.
//

import WidgetKit

@frozen
enum AppGroup: String, CaseIterable {
    case app = "group.MeetWidget"
    case increase
    case decrease
}

protocol WidgetHelperImpl {
    func incrementCount(kind: AppGroup)
    func decrementCount(kind: AppGroup)
}

final class WidgetHelper: WidgetHelperImpl {
    func save(count: Int, kind: AppGroup = .increase) {
        if let defaults = UserDefaults.init(suiteName: AppGroup.app.rawValue) {
            defaults.set(count, forKey: kind.rawValue)
            defaults.synchronize()
        }
        self.reloadAllWidgets()
    }
    
    func load(kind: AppGroup) -> Int {
        if let defaults = UserDefaults.init(suiteName: AppGroup.app.rawValue) {
            return defaults.integer(forKey: kind.rawValue)
        } else {
            return 0
        }
    }
    
    func incrementCount(kind: AppGroup) {
        let currentCount = load(kind: kind)
        let newCount = currentCount + 1
        save(count: newCount)
    }
    
    func decrementCount(kind: AppGroup) {
        let currentCount = load(kind: kind)
        let newCount = currentCount - 1
        save(count: newCount)
    }
}

private extension WidgetHelper {
    func reloadAllWidgets() {
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func reloadWidget(kind: AppGroup) {
        WidgetCenter.shared.reloadTimelines(ofKind: kind.rawValue)
    }
}

