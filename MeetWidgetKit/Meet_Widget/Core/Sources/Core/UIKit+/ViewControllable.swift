//
//  ViewControllable.swift
//  MeetWidgetKit
//
//  Created by MEGA_Mac on 2024/05/29.
//

import Network
import UIKit

public typealias ViewControllable = ViewControllerSupportImpl & NetworkMonitorImpl

public protocol ViewControllerSupportImpl {}

extension ViewControllerSupportImpl where Self: UIViewController {
    public func setBackgroundColor() {
        self.view.backgroundColor = .white
    }
}

public protocol NetworkMonitorImpl {}

extension NetworkMonitorImpl where Self: UIViewController {
    public func startMonitoringNetwork() {
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.view.backgroundColor = path.status == .satisfied ? .white : .yellow
            }
        }
        monitor.start(queue: queue)
    }
}
