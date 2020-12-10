//
//  NetworkService.swift
//  NYTimes
//
//  Created by Michael Grigoryan on 12/9/20.
//

protocol NetworkServiceDelegate: class {
    
    // MARK: - Methods
    
    func networkBecomesReachable()
    func networkBecomesUnreachable()
}

import Reachability

class NetworkService: NSObject {
    
    // MARK: - Instance

    static let shared = NetworkService()
    
    // MARK: - Properties
    
    private let reachability = try? Reachability()
    
    var isNetworkConnected: Bool {
        return reachability?.connection == .wifi || reachability?.connection == .cellular
    }
    
    private var wasPreviouslyConnected: Bool = false
    
    weak var delegate: NetworkServiceDelegate?
    
    // MARK: - Methods
    
    func startNotifier() {
        reachability?.whenReachable = { _ in
            guard !self.wasPreviouslyConnected else { return }
            self.wasPreviouslyConnected = true
            self.delegate?.networkBecomesReachable()
        }
        reachability?.whenUnreachable = { _ in
            self.wasPreviouslyConnected = false
            self.delegate?.networkBecomesUnreachable()
        }
        do { try reachability?.startNotifier()
        } catch let error { print(error.localizedDescription) }
    }
    
    deinit { reachability?.stopNotifier() }
}
