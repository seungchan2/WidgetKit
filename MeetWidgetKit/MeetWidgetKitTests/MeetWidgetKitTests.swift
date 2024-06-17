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

/*
 describe: Test Suite 그룹화하는 역할 (주로 테스트하려는 기능이나 특정 모듈에 대한 설명을 포함)
 context: 테스트 케이스를 더 구체적인 상황이나 조건에 따라 그룹화하는 역할
 it: 개별적인 테스트 케이스를 작성하는 곳
 */
final class WidgetHelperSpec: QuickSpec {
    override func spec() {
        var widgetHelper: WidgetHelper!
        
        beforeEach {
            widgetHelper = WidgetHelper.shared
        }
        
        describe("WidgetHelper") {
            context("+, - 버튼 클릭하면") {
                it("카운트된 횟수를 보여줍니다.") {
                    widgetHelper.save(count: 10, kind: .calculate)
                    let count = widgetHelper.load(kind: .calculate)
                    expect(count).to(equal(10))
                }
                
                it("횟수가 1 증가합니다.") {
                    widgetHelper.save(count: 10, kind: .calculate)
                    widgetHelper.calculateCount(operation: .sum)
                    let count = widgetHelper.load(kind: .calculate)
                    expect(count).to(equal(11))
                }
                
                it("횟수가 1 감소합니다.") {
                    widgetHelper.save(count: 10, kind: .calculate)
                    widgetHelper.calculateCount(operation: .minus)
                    let count = widgetHelper.load(kind: .calculate)
                    expect(count).to(equal(9))
                }
            }
                        
            context("fetch 버튼 클릭하면") {
                it("강아지 이미지를 불러오고 저장합니다.") {
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
