//
//  WidgetHelper.swift
//  MeetWidgetKit
//
//  Created by MEGA_Mac on 2024/05/29.
//

import WidgetKit
import UIKit

import ChanLog

/*
 MARK: App Groups 및 Widget kind enum
 */
@frozen
public enum AppGroup: String, CaseIterable {
    case app = "group.MeetWidget"
    case calculate = "CalculateWidget"
    case image = "DogImageWidget"
}

/*
 MARK: CalculateViewController의 +, - 버튼 구분 짓는 enum
 */
@frozen
public enum Operators: CaseIterable {
    case sum
    case minus
}

/*
 MARK: CalculateViewModel, DogViewModel에서 사용하는 protocol (DIP)
 */
public protocol CalculateHelperImpl {
    func calculateCount(operation: Operators)
}

public protocol ImageGeneratorImpl {
    func save(image: UIImage, kind: AppGroup)
}

/*
 @brief 앱 -> 위젯 데이터 저장하는 객체 (WidgetHelper)
 */
public final class WidgetHelper: CalculateHelperImpl, ImageGeneratorImpl {
    
    public static let shared = WidgetHelper()
    public init() {}
    
    // MARK: CalculateViewController +,- 버튼 클릭 시, 횟수 저장 -> 앱에서 사용
    public func save(count: Int, kind: AppGroup = .calculate) {
        if let defaults = UserDefaults.init(suiteName: AppGroup.app.rawValue) {
            count.info("+,- 버튼 클릭 시, 횟수 저장")
            defaults.set(count, forKey: kind.rawValue)
        }
        self.reloadWidget(kind: .calculate)
    }
    
    // MARK: DogViewController 이미지 버튼 클릭 시, 이미지 저장 -> 앱에서 사용
    public func save(image: UIImage, kind: AppGroup = .image) {
        if let defaults = UserDefaults.init(suiteName: AppGroup.app.rawValue), let data = image.pngData() {
            data.info("이미지 버튼 클릭 시, 이미지 저장")
            defaults.set(data, forKey: kind.rawValue)
        }
        self.reloadWidget(kind: kind)
    }
    
    // MARK: CalculateViewController +,- 버튼 클릭 시, 저장된 횟수 -> 위젯에서 사용
    public func load(kind: AppGroup = .calculate) -> Int {
        if let defaults = UserDefaults.init(suiteName: AppGroup.app.rawValue) {
            return defaults.integer(forKey: kind.rawValue)
        } else {
            return 0
        }
    }
    
    // MARK: DogViewController 저장된 이미지 -> 위젯에서 사용
    public func loadImage(kind: AppGroup = .image) -> UIImage? {
        if let defaults = UserDefaults(suiteName: AppGroup.app.rawValue),
           let data = defaults.data(forKey: kind.rawValue) {
            return UIImage(data: data)
        }
        return nil
    }
    
    private func calculateNewCount(currentCount: Int, operation: Operators) -> Int {
        switch operation {
        case .sum:
            return currentCount + 1
        case .minus:
            return currentCount - 1
        }
    }

    // MARK: Sprout Method
    public func calculateCount(operation: Operators) {
        let currentCount = load(kind: .calculate)
        let newCount = calculateNewCount(currentCount: currentCount, operation: operation)
        newCount.info("현재 횟수")
        newCount.minInfo("현재 횟수")
        save(count: newCount)
    }
}

/*
 Widget을 reload 하는 메소드
 1. reloadAllWidgets -> 모든 위젯 reload
 2. Widget kind 명에 따라 따로 reload가 가능함
 */
private extension WidgetHelper {
    func reloadAllWidgets() {
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func reloadWidget(kind: AppGroup) {
        WidgetCenter.shared.reloadTimelines(ofKind: kind.rawValue)
    }
}
