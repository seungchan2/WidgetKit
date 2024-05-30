//
//  SceneDelegate.swift
//  MeetWidgetKit
//
//  Created by MEGA_Mac on 2024/05/29.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        window?.rootViewController = UINavigationController(rootViewController: CalculateViewController(widgetService: WidgetHelper()))
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
        if url.scheme == "meetWidget" {
            if url.host == "image" {
                if !rootViewController.viewControllers.contains(where: { $0 is ImageViewController }) {
                    let secondViewController = ImageViewController(imageService: WidgetHelper())
                    rootViewController.pushViewController(secondViewController, animated: true)
                }
            }
        }
    }
}
