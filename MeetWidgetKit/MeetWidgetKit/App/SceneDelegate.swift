//
//  SceneDelegate.swift
//  MeetWidgetKit
//
//  Created by MEGA_Mac on 2024/05/29.
//

import UIKit

import CombineModule
import RxSwiftModule
import Core
import NetworkModule

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    private let dependencyContainer = DependencyStore.shared
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        window?.rootViewController = UINavigationController(rootViewController: dependencyContainer.registerCombineViewController())
        window?.makeKeyAndVisible()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        handleDeepLink(url)
    }
}

extension SceneDelegate {
    private func handleDeepLink(_ url: URL) {
        guard let rootViewController = window?.rootViewController as? UINavigationController else {
            return
        }
        // MARK: DogWidget에서 설정한 scheme에 따라 앱의 시작점 정의하는 코드
        if url.scheme == "meetWidget" {
            if url.host == "image" {
                if !rootViewController.viewControllers.contains(where: { $0 is DogImageViewController_Combine }) {
                    let destination = dependencyContainer.registerCombineDogViewController()
                    rootViewController.pushViewController(destination, animated: true)
                }
            }
        }
    }
}
