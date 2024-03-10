import UIKit

enum SharePathModel {
    case home
    case art(id: Int64)
    case exhibition(id: Int64)
    case profile(id: Int64)
}

final class SharePathManager {
    var applicationCoordinator: AppCoordinator?
    var sharePath: SharePathModel?
    
    init(applicationCoordinator: AppCoordinator?, pathString: String) {
        self.applicationCoordinator = applicationCoordinator
        if pathString == "/home" {
            sharePath = .home
        } else {
            let pathArray = pathString.split(separator: "/")
            if pathArray.count == 2 {
                let tab = pathArray[0]
                guard let id = Int64(pathArray[1]), id >= 0 else { return }
                switch tab {
                case "art":
                    sharePath = .art(id: id)
                case "exhibiton":
                    sharePath = .exhibition(id: id)
                case "profile":
                    sharePath = .profile(id: id)
                default:
                    sharePath = .home
                }
            }
        }
    }
    
    @MainActor
    func navigate() {
        // background, killed 분기
        
        
        // 링크를 통해 들어오면
        // home coordinator에서 출발
        
        guard let sharePath, let applicationCoordinator else { return }
        if applicationCoordinator.childCoordinators.count == 0 || applicationCoordinator.childCoordinators[0].childCoordinators.count == 0 {
            print("🔴🔴 login || main coordinator 없음 🔴🔴")
            return
        }
        switch sharePath {
        case .home:
            print("🔴🔴 home 으로 이동 🔴🔴")
            guard let homeCoordinator = applicationCoordinator.childCoordinators[0].childCoordinators[0].childCoordinators[0] as? HomeCoordinator else { return }
            homeCoordinator.childCoordinators.forEach { $0.close() }
            
            // 모든 coordinator에서 present하는걸 하나씩 닫아줘야 하는지?
            // manage해야할 coordinator를 어떻게 알수있는지?
            
            
        case .art(id: let id):
            print("🔴🔴 art, id: \(id) 으로 이동 🔴🔴")
            let mainCoordinator = applicationCoordinator.childCoordinators.first(where: { type(of: $0) == MainCoordinator.self})
            
            // home에 있는 경우
            guard let homeCoordinator = applicationCoordinator.childCoordinators[0].childCoordinators[0].childCoordinators[0] as? HomeCoordinator else { return }
            homeCoordinator.childCoordinators.forEach { $0.close() }
            
            homeCoordinator.navigate(to: .productDetail(id: id))
            
        case .exhibition(let id):
            print("exhibition \(id)")
        case .profile(let id):
            print("🔴🔴 마이페이지(profile) 이동, id: \(id) 🔴🔴")
        }
    }
}
