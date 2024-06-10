//
//  WidgetHelper.swift
//  MeetWidgetKit
//
//  Created by MEGA_Mac on 2024/05/29.
//

import WidgetKit
import UIKit

@frozen
public enum AppGroup: String, CaseIterable {
    case app = "group.MeetWidget"
    case calculate = "CalculateWidget"
    case image = "DogImageWidget"
}

@frozen
public enum Operators: CaseIterable {
    case sum
    case minus
}

public protocol CalculateHelperImpl {
    func calculateCount(operation: Operators)
}

public protocol ImageGeneratorImpl {
    func save(image: UIImage, kind: AppGroup)
}

public final class WidgetHelper: CalculateHelperImpl, ImageGeneratorImpl {
    
    public static let shared = WidgetHelper()
    public init() {}
    
    public func save(count: Int, kind: AppGroup = .calculate) {
        if let defaults = UserDefaults.init(suiteName: AppGroup.app.rawValue) {
            defaults.set(count, forKey: kind.rawValue)
        }
        self.reloadWidget(kind: .calculate)
    }
    
    public func save(image: UIImage, kind: AppGroup = .image) {
        if let defaults = UserDefaults.init(suiteName: AppGroup.app.rawValue), let data = image.pngData() {
            defaults.set(data, forKey: kind.rawValue)
        }
        self.reloadWidget(kind: kind)
    }
    
    public func load(kind: AppGroup = .calculate) -> Int {
        if let defaults = UserDefaults.init(suiteName: AppGroup.app.rawValue) {
            return defaults.integer(forKey: kind.rawValue)
        } else {
            return 0
        }
    }
    
    public func loadImage(kind: AppGroup = .image) -> UIImage? {
        if let defaults = UserDefaults(suiteName: AppGroup.app.rawValue),
           let data = defaults.data(forKey: kind.rawValue) {
            return UIImage(data: data)
        }
        return nil
    }
    
    public func calculateCount(operation: Operators) {
        let currentCount = load(kind: .calculate)
        var count = 0
        switch operation {
        case .sum:
            let newCount = currentCount + 1
            count = newCount
        case .minus:
            let newCount = currentCount - 1
            count = newCount
        }
        save(count: count)
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
