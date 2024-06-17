//
//  MeetWidgetKitTests.swift
//  MeetWidgetKitTests
//
//  Created by MEGA_Mac on 2024/05/29.
//

import XCTest
import Core
@testable import MeetWidgetKit

import Quick
import Nimble

final class WidgetHelperSpec: QuickSpec {
    override func spec() {
        var widgetHelper: WidgetHelper!
        
        beforeEach {
            widgetHelper = WidgetHelper.shared
        }
        
        describe("WidgetHelper") {
            context("횟수 저장 및 불러옵니다.") {
                
                it("카운트된 횟수를 보여줍니다.") {
                    widgetHelper.save(count: 10, kind: .calculate)
                    
                    let count = widgetHelper.load(kind: .calculate)
                    expect(count).to(equal(10))
                }
                
                it("+ 버튼 클릭 시, 횟수가 1 증가합니다.") {
                    widgetHelper.save(count: 10, kind: .calculate)
                    
                    widgetHelper.calculateCount(operation: .sum)
                    
                    let count = widgetHelper.load(kind: .calculate)
                    expect(count).to(equal(11))
                }
                
                it("- 버튼 클릭 시, 횟수가 1 감소합니다.") {
                    widgetHelper.save(count: 10, kind: .calculate)
                    
                    widgetHelper.calculateCount(operation: .minus)
                    
                    let count = widgetHelper.load(kind: .calculate)
                    expect(count).to(equal(9))
                }
            }
            
            context("강아지 이미지 저장하고 불러옵니다.") {
                it("fetch 버튼 클릭 시, 이미지를 불러오고 저장합니다.") {
                    let image = UIImage(systemName: "star.fill")!
                    widgetHelper.save(image: image, kind: .image)
                    
                    let loadedImage = widgetHelper.loadImage(kind: .image)
                    expect(loadedImage).toNot(beNil())
                    expect(loadedImage?.pngData()).to(equal(image.pngData()))
                }
            }
        }
    }
}
