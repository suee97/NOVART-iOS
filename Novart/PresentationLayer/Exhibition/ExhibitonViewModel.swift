import UIKit
import Combine
import ColorThiefSwift
import Kingfisher

final class ExhibitionViewModel {
    
    private let coordinator: ExhibitionCoordinator
    private var downloadInteractor: ExhibitionInteractor = ExhibitionInteractor()
    private var exhibitions = [ExhibitionModel]()
    var currentLikeStates: [Bool] = .init()
    var currentLikeCounts: [Int] = .init()
    
    @Published var processedExhibitions = [ProcessedExhibition]() // 후처리 된 전시 객체 배열
    @Published var cellIndex: Int? // 전시 인덱스
    
    init(coordinator: ExhibitionCoordinator) {
        self.coordinator = coordinator
    }
    
    func fetchExhibitions() {
        Task {
            do {
                let items = try await downloadInteractor.fetchExhibitions()
                self.exhibitions = items
                self.currentLikeStates = exhibitions.map { $0.likes }
                self.currentLikeCounts = exhibitions.map { $0.likesCount }
                await processExhibitions()
                
            } catch {
                print(error)
            }
        }
    }
    
    @MainActor
    private func processExhibitions() async {
        var processedExhibitions: [ProcessedExhibition] = []
        
        for e in exhibitions {
            guard let posterUrl = e.posterImageUrl,
                  let url = URL(string: posterUrl) else { return }
            
            let imageView = UIImageView()
            
            let processedExhibition: ProcessedExhibition? = await withCheckedContinuation { continuation in
                imageView.kf.setImage(with: url, completionHandler: { _ in
                    if let dominant = ColorThief.getColor(from: imageView.image ?? UIImage())?.makeUIColor() {
                        let hueValue = dominant.getHsb().0
                        let hsbColor = UIColor(hue: hueValue / 360, saturation: 0.08, brightness: 0.95, alpha: 1.0)
                        
                        continuation.resume(returning: ProcessedExhibition(id: Int(e.id), imageView: imageView, description: e.description, likesCount: e.likesCount, commentCount: e.commentCount, likes: e.likes, backgroundColor: hsbColor))
                    } else {
                        continuation.resume(returning: nil)
                    }
                })
            }
            
            if let processedExhibition {
                processedExhibitions.append(processedExhibition)
            }
        }
        
        self.processedExhibitions = processedExhibitions
    }
    
    @MainActor
    func showExhibitionDetail(exhibitionId: Int64) {
        coordinator.navigate(to: .exhibitionDetail(id: exhibitionId))
    }
    
    @MainActor
    func didTapLikeButton(shouldLike: Bool) {
        if !Authentication.shared.isLoggedIn {
            coordinator.navigate(to: .login)
        } else {
            if shouldLike {
                makeLikeRequest()
            } else {
                makeUnlikeRequest()
            }
        }
    }
    
    @MainActor
    func didTapCommentButton() {
        showCommentViewController()
    }
    
    @MainActor
    func presentLoginModal() {
        coordinator.navigate(to: .login)
    }
    
    func didTapShareButton() {
        guard let cellIndex else { return }
        let exhibitionId = processedExhibitions[cellIndex].id
        let dataToShare = "https://\(URLSchemeFactory.plainURLScheme).com/exhibition/\(exhibitionId)"
        let activityController = ActivityController(activityItems: [dataToShare], applicationActivities: nil)
        activityController.show()
    }
}

private extension ExhibitionViewModel {
    func makeLikeRequest() {
        guard let cellIndex else { return }
        let exhibitionId = exhibitions[cellIndex].id
        Task {
            do {
                try await downloadInteractor.makeLikeRequest(id: exhibitionId)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func makeUnlikeRequest() {
        guard let cellIndex else { return }
        let exhibitionId = exhibitions[cellIndex].id
        Task {
            do {
                try await downloadInteractor.makeUnlikeRequest(id: exhibitionId)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    @MainActor
    func showCommentViewController() {
        guard let cellIndex else { return }
        let exhibitionId = exhibitions[cellIndex].id
        coordinator.navigate(to: .comment(id: exhibitionId))
    }
}
