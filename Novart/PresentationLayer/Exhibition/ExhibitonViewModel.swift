import UIKit
import Combine
import ColorThiefSwift
import Kingfisher

final class ExhibitionViewModel {
    
    private let coordinator: ExhibitionCoordinator
    private var downloadInteractor: ExhibitionInteractor = ExhibitionInteractor()
    private var exhibitions = [Exhibition]()
    
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
                await self.processExhibitions()
            } catch {
                print(error)
            }
        }
    }
    
    @MainActor
    private func processExhibitions() {
        for e in exhibitions {
            guard let url = URL(string: e.posterImageUrl) else { return }
            
            let imageView = UIImageView()
            imageView.kf.setImage(with: url, completionHandler: { _ in
                if let dominant = ColorThief.getColor(from: imageView.image ?? UIImage())?.makeUIColor() {
                    let hueValue = dominant.getHsb().0
                    let hsbColor = UIColor(hue: hueValue / 360, saturation: 0.08, brightness: 0.95, alpha: 1.0)
                    
                    // 처리 후 데이터
                    self.processedExhibitions.append(ProcessedExhibition(id: e.id, imageView: imageView, description: e.description, likesCount: e.likesCount, commentCount: e.commentCount, liked: e.liked, backgroundColor: hsbColor))
                }
            })
        }
    }
}
