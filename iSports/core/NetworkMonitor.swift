
import Foundation
import Alamofire

final class NetworkMonitor {

    static let shared = NetworkMonitor()

    private let reachabilityManager = NetworkReachabilityManager()

    private(set) var isConnected = true

    private init() {
        startListening()
    }

    private func startListening() {
        reachabilityManager?.startListening { [weak self] status in
            switch status {
            case .reachable(.cellular), .reachable(.ethernetOrWiFi):
                self?.isConnected = true

            case .notReachable, .unknown:
                self?.isConnected = false
            }
        }
    }
}
