//
//  NetworkMonitor.swift
//  CleanArchitecture
//
//  Created by Sophearath.chhan on 10/9/26.
//

import Network
import SwiftUI

public protocol NetworkMonitoring {
    var isConnected: Bool { get }
}

public final class NetworkMonitor: NetworkMonitoring {
    public static let shared = NetworkMonitor()

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    private let lock = NSLock()
    private var _isConnected = true

    public var isConnected: Bool {
        lock.lock()
        defer {
            lock.unlock()
        }
        return _isConnected
    }

    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self else { return }
            self.lock.lock()
            self._isConnected = (path.status == .satisfied)
            self.lock.unlock()
        }
        monitor.start(queue: queue)
    }
}
