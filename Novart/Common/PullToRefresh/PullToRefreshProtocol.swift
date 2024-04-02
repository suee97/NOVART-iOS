import UIKit

protocol PullToRefreshProtocol {
    var refreshControl: PlainRefreshControl { get set }
    func setupRefreshControl()
    func onRefresh()
}
