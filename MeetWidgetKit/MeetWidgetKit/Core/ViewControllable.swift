//
//  ViewControllable.swift
//  MeetWidgetKit
//
//  Created by MEGA_Mac on 2024/05/29.
//

import Network
import UIKit

typealias ViewControllable = ViewControllerSupportImpl & NetworkMonitorImpl

protocol ViewControllerSupportImpl {}

extension ViewControllerSupportImpl where Self: UIViewController {
    func setBackgroundColor() {
        self.view.backgroundColor = .white
    }
}

protocol NetworkMonitorImpl {}

extension NetworkMonitorImpl where Self: UIViewController {
    func startMonitoringNetwork() {
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.view.backgroundColor = path.status == .satisfied ? .green : .yellow
            }
        }
        monitor.start(queue: queue)
    }
}
